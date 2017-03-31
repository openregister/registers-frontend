require 'deskpro_feedback'
require 'json'

module Spina
  class SupportsController < Spina::ApplicationController

    layout "layouts/default/application"

    def index
    end

    def new
      @wizard = ModelWizard.new(Spina::Support, session, params).start
      @support = @wizard.object
    end

    def create
      @wizard = ModelWizard.new(Spina::Support, session, params, support_params).continue
      @support = @wizard.object
      if @wizard.save
        @deskproService = DeskproFeedback.new(support_params)
        @response = @deskproService.send_feedback
        if @response.status.code != 201
          logger.debug("Feedback ticket creation failed with status: #{@response.status} and content: #{@response.body}")
        end
        redirect_to spina.supports_path
      else
        flash.now[:errors] = @support.errors[:base].first
        render :new
      end
    end

    private
      def support_params
        return params unless params[:support]

        params.require(:support).permit(
          :current_step,
          :subject,
          :register_name,
          :name,
          :email,
          :message
        )
      end
  end
end
