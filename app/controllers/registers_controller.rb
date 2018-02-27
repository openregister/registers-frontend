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

    sort_by = params[:sort_by] ||= default_sort_by.call
    sort_direction = params[:sort_direction] ||= 'asc'
    query = @register.records.where(entry_type: 'user')

    query = case params[:status]
            when 'archived'
              query.archived
            when 'all'
              query
            else
              query.current
            end

    if params[:q].present?
      search_query = fields.split(',')
                           .map { |f| "data->> '#{f}' ilike '%#{params[:q]}%'" }
                           .join(' or ')

      query = query.where(search_query)
    end

    query.order("data->> '#{sort_by}' #{sort_direction.upcase} nulls last").page(params[:page]).per(100)
  end
end
