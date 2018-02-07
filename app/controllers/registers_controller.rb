# frozen_string_literal: true

class RegistersController < ApplicationController
  include Search
  layout 'layouts/default/application'

  def index
    @search = Register.available.ransack(params[:q])

    @registers = case params[:phase]
                 when 'ready to use'
                   @search.result.where(register_phase: 'Beta').sort_by_phase_name_asc.by_name
                 when 'in progress'
                   @search.result.where.not(register_phase: 'Beta').sort_by_phase_name_asc.by_name
                 else
                   @search.result.sort_by_phase_name_asc.by_name
                 end
  end

  def show
    @register = Register.find_by_slug!(params[:id])
    @records = recover_records(@register.id, @register.fields, params)
  end

  def history
    @register = Register.find_by_slug!(params[:id])
    entries = recover_entries_history(@register.id, @register.fields, params)
    fields = @register.register_fields.map { |field| field['field'] }

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

  def recover_records(register_id, fields, params, page_size = 100)
    default_sort_by = lambda {
      has_name_field = fields.split(',').include?('name')
      has_name_field ? 'name' : params[:id]
    }

    search_term = params[:q]
    status = params[:status] ||= 'current'
    page = (params[:page] ||= 1).to_i
    sort_by = params[:sort_by] ||= default_sort_by.call
    sort_direction = params[:sort_direction] ||= 'asc'
    @total_record_count = Record.where(register_id: register_id, entry_type: 'user').count
    query = Record.where(register_id: register_id, entry_type: 'user')

    query = case status
            when 'archived'
              query.where("data->> 'end-date' is not null")
            when 'current'
              query.where("data->> 'end-date' is null")
            else
              query
            end

    if search_term.present?
      operation_params = []
      partial = ''

      fields.split(',').each { |field| partial += " data->> '#{field}' ilike ? or" }
      partial = partial[1, partial.length - 3]

      operation_params.push(partial)
      fields.split(',').count.times { operation_params.push("%#{search_term}%") }

      query = query.where(operation_params)
    end

    if sort_by.present? && sort_direction.present?
      query = query.order("data->> '#{sort_by}' #{sort_direction.upcase} nulls last")
    end
    @result_count = query.count
    @offset = page_size * (page - 1) + 1
    @offset_end = [@result_count, page_size * page].min

    @total_pages = (@result_count / 100) + ((@result_count % 100).zero? ? 0 : 1)

    query.page(page).per(page_size).without_count
  end

  def filter(entries, query)
    entries.select do |entry|
      entry[:key].downcase.include?(query.downcase) ||
        contain_value_filtered_by_field_names?(entry[:current_record], entry[:updated_fields], query) ||
        contain_value_filtered_by_field_names?(entry[:previous_record], entry[:updated_fields], query)
    end
  end
end
