# frozen_string_literal: true

class RegistersController < ApplicationController
  layout 'layouts/default/application'

  def index
    @search = Register.available.ransack(params[:q])
    @registers = @search.result.where(register_phase: 'Beta').sort_by_phase_name_asc.by_name

    # Redirect legacy URL to ensure we don't break anyone
    if params[:phase] == 'in progress'
      redirect_to registers_in_progress_path
    end
  end

  def in_progress
    @search = Register.available.ransack(params[:q])
    @upcoming_registers = @search.result.where(register_phase: 'Alpha').sort_by_phase_name_asc.by_name
    # We don't have search on the suggested registers so no need to pass in Ransack
    @suggested_registers = Register.available.where(register_phase: %w[Backlog Discovery]).sort_by_phase_name_asc.by_name
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

    sort_by = params[:sort_by] ||= default_sort_by.call
    sort_direction = params[:sort_direction] ||= 'asc'

    @register.records
             .where(entry_type: 'user')
             .search_for(fields, params[:q])
             .status(params[:status])
             .sort_by_field(sort_by, sort_direction)
             .page(params[:page])
             .per(100)
  end
end
