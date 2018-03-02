# frozen_string_literal: true

class RegistersController < ApplicationController
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
    @records = recover_records(@register.fields_array, params)
  end

private

  def recover_records(fields, params)
    default_sort_by = lambda {
      has_name_field = fields.include?('name')
      has_name_field ? 'name' : params[:id]
    }

    sort_by = params.fetch(:sort_by) { default_sort_by.call }
    sort_direction = params.fetch(:sort_direction) { 'asc' }
    query = @register.records
                     .where(entry_type: 'user')
                     .search_for(fields, params[:q])
                     .order("data->> '#{sort_by}' #{sort_direction.upcase} nulls last")
                     .page(params[:page])
                     .per(100)

    case params[:status]
    when 'archived'
      query.archived
    when 'all'
      query
    else
      query.current
    end
  end
end
