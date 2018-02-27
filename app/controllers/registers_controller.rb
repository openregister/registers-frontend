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
    @records = recover_records(@register.fields, params)
  end

private

  def recover_records(fields, params)
    default_sort_by = lambda {
      has_name_field = fields.split(',').include?('name')
      has_name_field ? 'name' : params[:id]
    }

    search_term = params[:q]
    status = params[:status]
    sort_by = params[:sort_by] ||= default_sort_by.call
    sort_direction = params[:sort_direction] ||= 'asc'
    query = @register.records.where(entry_type: 'user')

    query = case status
            when 'archived'
              query.where("data->> 'end-date' is not null")
            when 'all'
              query
            else
              query.current
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

    query.page(params[:page]).per(100)
  end
end
