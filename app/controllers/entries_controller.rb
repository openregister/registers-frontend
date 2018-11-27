# frozen_string_literal: true

class EntriesController < ApplicationController
  def index
    @register = Register.find_by_slug!(params[:register_id])
    entries = recover_entries_history(@register.id, @register.fields_array, params)

    @entries_with_items = entries.map do |entry_history|
      current_record = entry_history[:current_entry]

      if entry_history[:previous_entry].nil?
        changed_fields = @register.fields_array
      else
        previous_record = entry_history[:previous_entry]
        changed_fields = @register.fields_array.reject { |f| entry_history[:current_entry].data[f] == previous_record.data[f] }
      end

      { current_record: current_record, previous_record: previous_record, updated_fields: changed_fields, key: current_record.key }
    end

    @entries_with_items = Kaminari.paginate_array(@entries_with_items, total_count: @result_count)
                                  .page(@current_page)
                                  .per(100)
    @custom_dimension_3 = @register.register_phase == 'Alpha' ? 'Alpha' : 'Live'
  end

private

  def recover_entries_history(register_id, fields, params, page_size = 100)
    @search_term = search_term

    page = params.fetch(:page) { 1 }.to_i
    user_entries = Entry.where(register_id: register_id, entry_type: 'user')
                        .search_for(fields, @search_term)
    query = user_entries.with_limit(page, page_size)

    previous_entries_numbers = query.reject { |entry| entry.previous_entry_number.nil? }.map(&:previous_entry_number)
    previous_entries_query = Entry.where(register_id: register_id, entry_number: previous_entries_numbers)

    @result_count = user_entries.count

    query.map do |entry|
      entries = previous_entries_query.select { |previous_entry| previous_entry.entry_number == entry.previous_entry_number }.first
      { current_entry: entry, previous_entry: entries }
    end
  end

  def search_term
    params.permit(:q)[:q]
  end
end
