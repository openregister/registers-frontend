# frozen_string_literal: true

class EntriesController < ApplicationController
  before_action :set_register, only: :index
  helper_method :get_register_definition, :get_field_definitions

  layout 'layouts/default/application'

  def index
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

    @entries_with_items = Kaminari::paginate_array(@entries_with_items, total_count: @result_count).page(@current_page).per(100)
  end

  def get_register_definition(register_id = @register.id, key = "register:#{params[:register_id]}")
    Record.find_by(register_id: @register.id, key: key).data
  end

  def get_field_definitions
    ordered_field_keys = get_register_definition['fields'].map { |f| "field:#{f}" }
    Record.where(register_id: @register.id, key: ordered_field_keys)
      .order("position(key::text in '#{ordered_field_keys.join(',')}')")
      .map { |entry| entry[:data] }
  end

private

  def recover_entries_history(register_id, fields, params, page_size = 100)
    search_term = params[:q]
    page = (params[:page] ||= 1).to_i

    if search_term.present?
      partial = ''
      operation_params = []
      fields.split(',').each { |field| partial += " data->> '#{field}' ilike ? or" }
      partial = partial[1, partial.length - 3] # Remove beginning space and end 'or'

      operation_params.push(partial)
      fields.split(',').count.times { operation_params.push("%#{search_term}%") }

      query = Entry.where(register_id: register_id, entry_type: 'user').where(operation_params).order(:entry_number).reverse_order.limit(page_size).offset(page_size * (page - 1))
      count_query = Entry.where(register_id: register_id, entry_type: 'user').where(operation_params)
    else
      query = Entry.where(register_id: register_id, entry_type: 'user').order(:entry_number).reverse_order.limit(100).offset(100 * (page - 1))
      count_query = Entry.where(register_id: register_id, entry_type: 'user')
    end

    query = query.search_for(params[:q]) if search_term.present?
    count_query = Entry.where(register_id: register_id, entry_type: 'user')

    previous_entries_numbers = query.reject { |entry| entry.previous_entry_number.nil? }.map(&:previous_entry_number)
    previous_entries_query = Entry.where(register_id: register_id, entry_number: previous_entries_numbers)

    result = query.map do |entry|
      entries = previous_entries_query.select { |previous_entry| previous_entry.entry_number == entry.previous_entry_number }.first
      { current_entry: entry, previous_entry: entries }
    end
    @result_count = count_query.count
    @current_page = page
    @total_pages = (@result_count / page_size) + ((@result_count % 100).zero? ? 0 : 1)

    result
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
      value.downcase.include?(query.downcase)
    else
      value.any? { |v| contain?(v, query) }
    end
  end

  def contain_in_array?(field_values, request_value)
    field_values.any? { |value| contain?(value, request_value) }
  end

  def contain?(field_value, request_value)
    field_value.downcase.include?(request_value.downcase)
  end

  def set_register
    @register = Register.find_by_slug!(params[:register_id])
  end
end
