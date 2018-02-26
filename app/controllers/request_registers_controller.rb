class RequestRegistersController < ApplicationController
  def merge_from_params
    session[:request_register_params] ? session[:request_register_params].merge(params.permit(:email, :message, :subject)).except('step') : {}
  end

  def index
    @wizard = ModelWizard.new(RequestRegister.new(merge_from_params), session, params).start
    @request_register = @wizard.object
  end

  def create
    @wizard = ModelWizard.new(RequestRegister.new(merge_from_params), session, params, request_register_params).continue
    @request_register = @wizard.object

    if @wizard.save
      @zendesk_service = ZendeskFeedback.new
      @response = @zendesk_service.send_feedback(request_register_params)
      session[:request_register_params] = nil
      redirect_to request_register_complete_path
    else
      render :index
    end
  end

  def thanks; end

private

  def request_register_params
    return params unless params[:request_register]
    params.require(:request_register).permit(:current_step, :email, :message, :subject)
  end
end
