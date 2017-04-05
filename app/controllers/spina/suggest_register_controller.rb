require 'deskpro_feedback'
require 'json'

module Spina
  class SuggestRegisterController < Spina::ApplicationController

    default_form_builder GovukElementsFormBuilder::FormBuilder

    layout "layouts/default/application"

    def index
      @suggest_register = Spina::SuggestRegister.new
    end

    def thanks
    end

    def create
      @suggest_register = Spina::SuggestRegister.new(suggest_register_params)

      if @suggest_register.valid?
        @deskproService = DeskproFeedback.new(suggest_register_params)
        @response = @deskproService.send_feedback
        if @response.status.code != 201
          logger.debug("Suggest register ticket creation failed with status: #{@response.status} and content: #{@response.body}")
        end
        redirect_to spina.suggest_register_thanks_path
      else
        flash.now[:errors] = @suggest_register.errors[:base].first
        render :index
      end
    end

    private

      def suggest_register_params
        params.require(:suggest_register).permit(
          :subject,
          :name,
          :email,
          :message,
          :register_name
        )
      end
  end
end
