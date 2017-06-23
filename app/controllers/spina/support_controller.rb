require 'deskpro_feedback'
require 'json'

module Spina
  class SupportController < Spina::ApplicationController

    default_form_builder GovukElementsFormBuilder::FormBuilder

    layout "layouts/default/application"

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
        @deskproService = DeskproFeedback.new(support_params)
        @response = @deskproService.send_feedback
        if @response.status.code != 201
          logger.debug("Feedback ticket creation failed with status: #{@response.status} and content: #{@response.body}")
        end
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
end
