# frozen_string_literal: true

class RegistersController < ApplicationController
  include ActionView::Helpers::UrlHelper
  helper_method :field_link_resolver
  invisible_captcha only: :create_feedback, honeypot: :spam

  def index
    @search_term = search_term

    # Redirect legacy URL to ensure we don't break anyone
    if params[:phase] == 'in progress'
      redirect_to registers_in_progress_path
    end

    if params[:showby] == 'name' || @search_term.present?
      @show_by_selected = 'name'
      @registers_collection = Register.available
                           .in_beta
                           .search_registers(@search_term)
                           .by_name
    elsif params[:showby] == 'organisation'
      @show_by_selected = 'organisation'
      @registers_collection = Authority.with_a_register
    else
      @show_by_selected = 'category'
      @registers_collection = Category.themes
    end
  end

  def in_progress
    @registers = Register.available.where(register_phase: 'Alpha').sort_by_phase_name_asc.by_name

    @registers_available = Register.available_count
    @organisation_count = Register.organisation_count
  end

  def show
    @search_term = search_term
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

  def create_feedback
    @feedback = Feedback.new(feedback_params)

    if @feedback.valid?
      if @feedback.message.present?
        @zendesk_service = ZendeskFeedback.new
        @response = @zendesk_service.send_feedback(feedback_params)
      end
      flash[:success] = 'Thank you for your feedback'
      redirect_to register_path(params[:register_id])
    else
      flash.now[:alert] = true
      @register = Register.has_records.find_by_slug!(params[:register_id])
      @records = recover_records(@register.fields_array, params)
      render 'registers/show'
    end
  end

private

  def register_whitelist
    @register_whitelist ||= Register.has_records.pluck(:slug)
  end

  def search_term
    params.permit(:q)[:q]
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
             .search_for(fields, search_term)
             .status(params[:status])
             .sort_by_field(sort_by, sort_direction)
             .page(params[:page])
             .per(100)
  end

  def feedback_params
    params.require(:feedback).permit(
      :subject,
      :email,
      :message,
      :useful,
      :reason
    )
  end
end
