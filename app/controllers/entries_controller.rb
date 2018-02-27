# frozen_string_literal: true

class EntriesController < ApplicationController
  include Search
  layout 'layouts/default/application'

  def index
    @register = Register.find_by_slug!(params[:register_id])
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

    @entries_with_items = Kaminari::paginate_array(@entries_with_items).page(params[:page]).per(100)
  end

private

  def recover_entries_history(register_id, fields, params)
    if params[:q].present?
      partial = ''
      operation_params = []
      fields.split(',').each { |field| partial += " data->> '#{field}' ilike ? or" }
      partial = partial[1, partial.length - 3] # Remove beginning space and end 'or'

      operation_params.push(partial)
      fields.split(',').count.times { operation_params.push("%#{params[:q]}%") }

      query = Entry.where(register_id: register_id, entry_type: 'user').where(operation_params).order(:entry_number).reverse_order
    else
      query = Entry.where(register_id: register_id, entry_type: 'user').order(:entry_number).reverse_order
    end

    previous_entries_numbers = query.reject { |entry| entry.previous_entry_number.nil? }.map(&:previous_entry_number)
    previous_entries_query = Entry.where(register_id: register_id, entry_number: previous_entries_numbers)

    result = query.map do |entry|
      entries = previous_entries_query.select { |previous_entry| previous_entry.entry_number == entry.previous_entry_number }.first
      { current_entry: entry, previous_entry: entries }
    end

    result
  end
end
