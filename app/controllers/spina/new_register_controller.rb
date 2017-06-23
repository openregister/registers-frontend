require 'deskpro_feedback'
require 'json'

module Spina
  class NewRegisterController < Spina::ApplicationController

    layout 'layouts/default/application'

    def index
    end

    def select_request_or_suggest
      if params[:subject] == 'request'
        redirect_to new_register_request_register_path
      else
        redirect_to new_register_suggest_register_path
      end
    end

    def suggest_register
      @new_register = Spina::NewRegister.new
    end

    def request_register
      @new_register = Spina::NewRegister.new
    end

    def thanks
    end

    def create
      @new_register = Spina::NewRegister.new(new_register_params)

      if @new_register.valid?
        @deskproService = DeskproFeedback.new(new_register_params)
        @response = @deskproService.send_feedback
        redirect_to spina.new_register_thanks_path
      else
        flash[:errors] = @new_register.errors
        if params[:new_register][:subject] == 'Request a Register'
          render :request_register
        else
          render :suggest_register
        end
      end
    end

    private

      def new_register_params
        params.require(:new_register).permit(
          :subject,
          :name,
          :email,
          :message
        )
      end
  end
end
