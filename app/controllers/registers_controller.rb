# frozen_string_literal: true

class RegistersController < ApplicationController
  def index
    if params[:q].present?
      @registers = Register.available.in_beta.search_for(params[:q])
    elsif params[:sort].present?
      case params[:sort]
      when 'name'
        @registers = Register.available.in_beta.by_name
      when 'popularity'
        @registers = Register.available.in_beta.order(position: :asc)
      end
    else
      @registers = Register.available.in_beta
    end

    # Redirect legacy URL to ensure we don't break anyone
    if params[:phase] == 'in progress'
      redirect_to registers_in_progress_path
    end
  end

  def in_progress
    @upcoming_registers = Register.available.where(register_phase: 'Alpha').sort_by_phase_name_asc.by_name

    @suggested_registers = Register.available.where(register_phase: %w[Backlog Discovery]).sort_by_phase_name_asc.by_name
  end

  def show
    @register = Register.find_by_slug!(params[:id])
    @records = recover_records(@register.fields_array, params)
    @feedback = Feedback.new
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
