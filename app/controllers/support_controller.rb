require 'json'

class SupportController < ApplicationController

  default_form_builder GovukElementsFormBuilder::FormBuilder

  def index
  end

  def select_support
    if params[:subject] == "problem"
      redirect_to support_problem_path
    else
      redirect_to support_question_path
    end
  end

  def problem
    @support = Spina::Support.new
  end

  def question
    @support = Spina::Support.new
  end

  def create
    @support = Spina::Support.new(support_params)

    if @support.valid?
      @zendeskService = ZendeskFeedback.new
      @response = @zendeskService.send_feedback(support_params)
      redirect_to spina.support_thanks_path
    else
      flash[:errors] = @support.errors
      if params[:subject] == "problem"
        render :problem
      else
        render :question
      end
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
