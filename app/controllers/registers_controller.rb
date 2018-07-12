# frozen_string_literal: true

class RegistersController < ApplicationController
  include ActionView::Helpers::UrlHelper
  helper_method :field_link_resolver

  def index
    @registers = Register.available
                         .in_beta
                         .search_registers(params[:q])

    # Redirect legacy URL to ensure we don't break anyone
    if params[:phase] == 'in progress'
      redirect_to registers_in_progress_path
    end
  end

  def in_progress
    @registers = Register.available.where(register_phase: 'Alpha').sort_by_phase_name_asc.by_name
  end

  def show
    @register = Register.has_records.find_by_slug!(params[:id])
    @records = recover_records(@register.fields_array, params)
    @feedback = Feedback.new
  end

  def field_link_resolver(field, field_value, register_slug: @register.slug, whitelist: register_whitelist)
    resolver = LinkResolver.new(current_register_slug: register_slug, register_whitelist: whitelist)

    if field_value.is_a?(Array)
      field_value.map { |fv| resolver.resolve(field, fv) }.join(', ').html_safe
    else
      resolver.resolve(field, field_value)
    end
  end

private

  def register_whitelist
    @register_whitelist ||= Register.has_records.pluck(:slug)
  end

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
