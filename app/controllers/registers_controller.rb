# frozen_string_literal: true

class RegistersController < ApplicationController
  helper_method :get_last_timestamp, :get_register_definition, :get_field_definitions


  def index
    @search = Spina::Register.ransack(params[:q])

    @registers = if params[:phase] == 'ready to use'
                   @search.result.where(register_phase: 'Beta').sort_by_phase_name_asc.by_name
                 elsif params[:phase] == 'in progress'
                   @search.result.where.not(register_phase: 'Beta').sort_by_phase_name_asc.by_name
                 else
                   @search.result.sort_by_phase_name_asc.by_name
                 end

    @current_phases = Spina::Register::CURRENT_PHASES
  end

  def get_last_timestamp
    Record.select('timestamp')
      .where(spina_register_id: @register.id, entry_type: 'user')
      .order(timestamp: :desc)
      .first[:timestamp]
      .to_s
  end

  def get_register_definition(register_id, key)
    Record.find_by(spina_register_id: register_id, key: key).data
  end

  def get_field_definitions
    ordered_field_keys = get_register_definition(@register.id, "register:#{params[:id]}")['fields'].map { |f| "field:#{f}" }
    Record.where(spina_register_id: @register.id, key: ordered_field_keys)
      .order("position(key::text in '#{ordered_field_keys.join(',')}')")
      .map { |entry| entry[:data] }
  end

  def show
    @register = Spina::Register.find_by_slug!(params[:id])
    @records = recover_records(@register.id, @register.fields, params)
  end

  def history
    @register = Spina::Register.find_by_slug!(params[:id])
    entries = recover_entries_history(@register.id, @register.fields, params)
    fields = get_field_definitions.map { |field| field['field'] }

    @entries_with_items = entries.map do |entry_history|
      current_record = entry_history[:current_entry]

      if entry_history[:previous_entry].nil?
        changed_fields = fields
      else
        previous_record = entry_history[:previous_entry]
        changed_fields = fields.reject { |f| entry_history[:current_entry].data[f] == previous_record.data[f] }
      end

      { current_record: current_record, previous_record: previous_record, updated_fields: changed_fields, key: current_record.key }
    end

    @entries_with_items = Kaminari::paginate_array(@entries_with_items, total_count: @page_count).page(@current_page).per(100)
  end

  private


  def recover_entries_history(register_id, fields, params)
    literal = params[:q]
    page = params[:page].nil? ? 1 : params[:page].to_i

    if literal.present?
      partial = ''
      operation_params = []
      fields.split(',').each { |field| partial += " data->> '#{field}' ilike ? or" }
      partial = partial[1, partial.length - 3] # Remove beginning space and end 'or'

      operation_params.push(partial)
      fields.split(',').count.times { operation_params.push("%#{literal}%") }

      query = Entry.where(spina_register_id: register_id, entry_type: 'user').where(operation_params).order(:entry_number).reverse_order.limit(100).offset(100 * (page - 1))
      count_query = Entry.select(1).where(spina_register_id: register_id, entry_type: 'user').where(operation_params)
    else
      query = Entry.where(spina_register_id: register_id, entry_type: 'user').order(:entry_number).reverse_order.limit(100).offset(100 * (page - 1))
      count_query = Entry.select(1).where(spina_register_id: register_id, entry_type: 'user')
    end

    previous_entries_numbers = query.reject{ |entry| entry.previous_entry_number.nil? }.map{ |entry| entry.previous_entry_number }
    previous_entries_query = Entry.where(spina_register_id: register_id, entry_number: previous_entries_numbers)

    result = query.map do |entry|
      previous_entry = previous_entries_query.select{ |previous_entry| previous_entry.entry_number == entry.previous_entry_number }.first
      { current_entry: entry, previous_entry: previous_entry }
    end

    @page_count = count_query.length
    @current_page = page
    @total_pages = (@page_count / 100) + (@page_count % 100 == 0 ? 0 : 1)

    result
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
    record.data.each do |field_name, field_value|
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
end