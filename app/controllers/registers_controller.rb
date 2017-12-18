# frozen_string_literal: true

class RegistersController < ApplicationController
  helper_method :get_last_timestamp, :get_register_definition, :get_field_definitions

  layout 'layouts/default/application'

  def index
    @search = Spina::Register.ransack(params[:q])

    @registers = if params[:phase] == 'ready to use'
                   @search.result.where(register_phase: 'Beta').sort_by_phase_name_asc.by_name
                 elsif params[:phase] == 'in progress'
                   @search.result.where.not(register_phase: 'Beta').sort_by_phase_name_asc.by_name
                 else
                   @search.result.sort_by_phase_name_asc.by_name
                 end

    @page = Spina::Page.find_by(name: 'registerspage')
    @current_phases = Spina::Register::CURRENT_PHASES

    # Fetch the register register for each phase and get records
    beta_register_register = @registers_client.get_register('register', 'beta').get_records
    alpha_register_register = @registers_client.get_register('register', 'alpha').get_records
    discovery_register_register = @registers_client.get_register('register', 'discovery').get_records
    @register_registers = beta_register_register.to_a + alpha_register_register.to_a + discovery_register_register.to_a
  end

  def get_last_timestamp
    Record.select('timestamp')
      .where(spina_register_id: @register.id, entry_type: 'user')
      .limit(1)
      .order(timestamp: :desc)
      .first[:timestamp].to_s
  end

  def get_register_definition
    Record.find_by(spina_register_id: @register.id, key: "register:#{params[:id]}").data
  end

  def get_field_definitions
    ordered_field_keys = get_register_definition['fields'].map { |f| "field:#{f}" }
    Record.where(spina_register_id: @register.id)
      .where(key: ordered_field_keys)
      .order("position(key::text in '#{ordered_field_keys.join(',')}')")
      .map { |entry| entry[:data] }
  end

  def show
    @register = Spina::Register.find_by_slug!(params[:id])

    unless @register.populated
      populate_register(@register)
    end

    @records = recover_records(@register.id, @register.fields, params)
  end

  def history
    @register = Spina::Register.find_by_slug!(params[:id])
    @register_data = @registers_client.get_register(@register.name.parameterize, @register.register_phase)
    fields = @register_data.get_field_definitions.map { |field| field.item.value['field'] }
    all_records = @register_data.get_records_with_history
    entries_reversed = @register_data.get_entries.reverse_each

    entries_mapped_with_items = entries_reversed.map do |entry|
      records_for_key = all_records.get_records_for_key(entry.key)
      current_record = records_for_key.detect { |record| record.entry.entry_number == entry.entry_number }
      previous_record_index = records_for_key.find_index(current_record) - 1

      if previous_record_index.negative?
        changed_fields = fields
      else
        previous_record = records_for_key[previous_record_index]
        changed_fields = fields.reject { |f| current_record.item.value[f] == previous_record.item.value[f] }
      end

      { current_record: current_record, previous_record: previous_record, updated_fields: changed_fields, key: entry.key }
    end

    if params[:q].present?
      filtered = filter(entries_mapped_with_items, params[:q])
      @entries_with_items = paginate_history(filtered)
    else
      @entries_with_items = paginate_history(entries_mapped_with_items)
    end
  end

  private

  def populate_register(register)
    register_data = @registers_client.get_register(register.name.parameterize, register.register_phase)

    populate_user_data(register, register_data)
    populate_system_data(register, register_data)

    register.populated = true
    register.fields = register_data.get_field_definitions.map { |field| field.item.value['field'] }.join(',')
    register.save
  end

  def populate_user_data(register, register_data)
    entries = []
    records = []
    count = 0

    register_data.get_records_with_history.each do |record|
      record[:records].each_with_index do |value, idx|
        count += 1
        new_entry = Entry.new(spina_register: register, timestamp: value.entry.timestamp, hash_value: value.entry.hash, entry_type: 'user', key: record[:key], data: value.item.value)
        entries.push(new_entry)

        if idx == record[:records].length - 1 # The last entry is the record
          records.push(Record.new(spina_register: register, timestamp: value.entry.timestamp, hash_value: value.entry.hash, entry_type: 'user', key: record[:key], data: value.item.value))
        end
      end

      next unless (count % 1000).zero?

      bulk_save(entries, records)

      entries = []
      records = []
    end

    # Remaining objects less than 1000
    bulk_save(entries, records)
  end

  def populate_system_data(register, register_data)
    entries = []
    records = []

    register_data.get_metadata_records.each do |record|
      new_entry = Entry.new(spina_register: register, data: record.item.value, timestamp: record.entry.timestamp, hash_value: record.entry.hash, entry_type: 'system', key: record.entry.key)
      entries.push(new_entry)
      records.push(Record.new(spina_register: register, data: record.item.value, timestamp: record.entry.timestamp, hash_value: record.entry.hash, entry_type: 'system', key: record.entry.key))
    end

    bulk_save(entries, records)
  end

  def recover_records(register_id, fields, params)
    literal, status, page, sort_by, sort_direction = params[:q], params[:status], params[:page], params[:sort_by], params[:sort_direction]

    query = Record.where(spina_register_id: register_id, entry_type: 'user')

    count_query = Record.select(1).where(spina_register_id: register_id, entry_type: 'user')

    if status == 'archived'
      query = query.where("data->> 'end-date' is not null")
      count_query = query.where("data->> 'end-date' is not null")
    elsif status == 'current'
      query = query.where("data->> 'end-date' is null")
      count_query = query.where("data->> 'end-date' is null")
    end

    if literal.present?
      operation_params = []
      partial = ''

      fields.split(',').each { |field| partial += " data->> '#{field}' ilike ? or" }
      partial = partial[1, partial.length - 3]

      operation_params.push(partial)
      fields.split(',').count.times { operation_params.push("%#{literal}%") }

      query = query.where(operation_params)
      count_query = query.where(operation_params)
    end

    if sort_by.present? && sort_direction.present?
      query = query.order("data->> '#{sort_by}' #{sort_direction.upcase}")
    end

    @page_count = count_query.length

    @total_pages = (@page_count / 100) + (@page_count % 100 == 0 ? 0 : 1)

    query.page(page).per(100).without_count
  end

  def bulk_save(entries, records)
    Entry.import(entries)
    Record.import(records)
  end

  def filter(entries, query)
    entries.select do |entry|
      entry[:key].downcase.include?(query.downcase) ||
        contain_value_filtered_by_field_names?(entry[:current_record], entry[:updated_fields], query) ||
        contain_value_filtered_by_field_names?(entry[:previous_record], entry[:updated_fields], query)
    end
  end

  def search(records, query)
    records.select { |r| contain_value?(r.item, query) }
  end

  def contain_value_filtered_by_field_names?(record, updated_fields, query)
    return false if record.nil?
    record.item.value.each do |field_name, field_value|
      next unless updated_fields.include?(field_name)

      return true if contain?(field_name, query)

      return true if include?(field_value, query)
    end

    false
  end

  def contain_value?(item, query)
    return false if item.nil?

    item.value.values.any? { |value| include?(value, query) }
  end

  def include?(value, query)
    if value.is_a?(String)
      return true if contain?(value, query)
    else
      return true if contain_in_array?(value, query)
    end

    false
  end

  def contain_in_array?(field_values, request_value)
    field_values.any? { |value| contain?(value, request_value) }
  end

  def contain?(field_value, request_value)
    field_value.downcase.include?(request_value.downcase)
  end

  def paginate_history(records)
    # TODO: Remove this method after migrate history functionality to DB and ORM
    Kaminari.paginate_array(records).page(params[:page]).per(100)
  end
end
