# frozen_string_literal: true

class RegistersController < ApplicationController
  include ActionView::Helpers::UrlHelper
  helper_method :field_link_resolver

  def index
    @search_term = search_term

    # Redirect legacy URL to ensure we don't break anyone
    if params[:phase] == 'in progress'
      redirect_to registers_in_progress_path
    end

    if params[:show_by] == 'name' || @search_term.present?
      @show_by_selected = 'name'
      @registers_collection = Register.available
                           .in_beta
                           .search_registers(@search_term)
                           .by_name
    elsif params[:show_by] == 'organisation'
      @show_by_selected = 'organisation'
      @registers_collection = Authority.with_a_register
    else
      @show_by_selected = 'category'
      @registers_collection = Category.with_a_register
    end
  end

  def in_progress
    @registers = Register.available.where(register_phase: 'Alpha').sort_by_phase_name_asc.by_name

    @registers_available = Register.available_count
    @organisation_count = Register.organisation_count
  end

  def show
    @register = Register.has_records.find_by_slug!(params[:id])

    @records = recover_records(@register.fields_array, params)
    @records_unfiltered = recover_records(@register.fields_array, params, true)

    @register_fields_with_examples = @register.fields_with_examples

    @register_records_total_count = @register.number_of_records

    @show_load_more = @register.is_register_published_by_dcms? # only show 'Load more' for registers published by DCMS

    if cookies[:seen_help_us_improve_questions]
      @next_step_api = register_use_the_api_path(@register.slug)
      @next_step_download = register_download_path(@register.slug)
    else
      @next_step_api = register_help_improve_api_path(@register.slug)
      @next_step_download = register_help_improve_download_path(@register.slug)
    end
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

  def search_term
    params.permit(:q)[:q]
  end

  def recover_records(fields, params, unfiltered = false)
    default_sort_by = lambda {
      fields.include?('name') ? 'name' : params[:id]
    }

    sort_by = params[:sort_by] ||= default_sort_by.call

    amount = @register.is_register_published_by_dcms? ? 10 : 5

    if unfiltered == true
      @register.records
             .where(entry_type: 'user')
             .sort_by_field(sort_by, 'asc')
    else
      @register.records
              .where(entry_type: 'user')
              .sort_by_field(sort_by, 'asc')
              .page(params[:page])
              .per(amount)
    end
  end
end
