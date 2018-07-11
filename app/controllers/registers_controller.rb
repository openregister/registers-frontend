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
    if field_value.is_a?(Array)
      field_value.map { |fv| resolve_single_link(field, fv, register_slug: register_slug, whitelist: whitelist) }.join(', ').html_safe
    else
      resolve_single_link(field, field_value, register_slug: register_slug, whitelist: whitelist)
    end
  end

  private

  def register_whitelist
    @register_whitelist ||= Register.has_records.pluck(:slug)
  end

  def resolve_single_link(f, fv, register_slug: @register.slug, whitelist: register_whitelist)
    field_register_slug = f['register']
    field_name = f['field']

    if f['datatype'] == 'curie' && fv.include?(':')
      curie_register, curie_key = fv.split(':')

      if !whitelist.include?(curie_register)
        fv
      elsif curie_key.present?
        link_to(fv, register_record_path(curie_register, curie_key))
      else
        link_to(fv, register_path(curie_register))
      end

    elsif field_register_slug.present? && field_name != register_slug && whitelist.include?(field_register_slug)
      link_to(fv, register_record_path(field_register_slug, fv))
    elsif f['datatype'] == 'url'
      link_to(fv, fv)
    else
      fv
    end
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
