require 'json'

class SupportController < ApplicationController
  default_form_builder GovukElementsFormBuilder::FormBuilder

  def index; end

  def select_support
    if params[:group] == 'public'
      redirect_to support_public_path
    else
      redirect_to support_question_path
    end
  end

  def question
    @support = Support.new
  end

  def create
    @support = Support.new(support_params)

    if @support.valid?
      @zendesk_service = ZendeskFeedback.new
      @response = @zendesk_service.send_feedback(support_params)

      redirect_to support_thanks_path
    else
      flash[:errors] = @support.errors

      render :question
    end
  end

private

  def support_params
    params.require(:support).permit(
      :subject,
      :name,
      :email,
      :message
    )
  end
end
