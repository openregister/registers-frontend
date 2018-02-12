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

private

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
    query = @register.records.where(entry_type: 'user')
    @total_record_count = query.count

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
end
