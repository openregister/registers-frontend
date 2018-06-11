# frozen_string_literal: true

class RegistersController < ApplicationController
  include ActionView::Helpers::UrlHelper
  helper_method :field_link_resolver

  def index
    @registers = Register.available
                         .in_beta
                         .search_registers(params[:q])
                         .sort_registers(params[:sort])

    # Redirect legacy URL to ensure we don't break anyone
    if params[:phase] == 'in progress'
      redirect_to registers_in_progress_path
    end
  end

  def in_progress
    @registers = Register.available.where(register_phase: 'Alpha').sort_by_phase_name_asc.by_name
  end

  def show
    @register = Register.find_by_slug!(params[:id])
    @records = recover_records(@register.fields_array, params)
    @feedback = Feedback.new
  end

  def field_link_resolver(field, field_value, register_slug = @register.slug)
    single_resolver = lambda { |f, fv|
      if f['register'].present? && f['field'] != register_slug
        link_to(fv, register_path(f['register'], record: fv, anchor: 'records_wrapper'))
      elsif f['datatype'] == 'url'
        link_to(fv, fv)
      elsif f['datatype'] == 'curie'
        curie = fv.split(':')
        link_to(curie[0], register_path(curie[0])) + ':' + link_to(curie[1], register_path(curie[0], record: curie[1], anchor: 'records_wrapper'))
      else
        fv
      end
    }

    cardinality_n_links = -> { field_value.map { |fv| single_resolver.call(field, fv) }.join(', ').html_safe }

    field_value.is_a?(Array) ? cardinality_n_links.call : single_resolver.call(field, field_value)
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
             .record(params[:record])
             .status(params[:status])
             .sort_by_field(sort_by, sort_direction)
             .page(params[:page])
             .per(100)
  end
end
