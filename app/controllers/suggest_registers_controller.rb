class SuggestRegistersController < ApplicationController
  def merge_from_params
    session[:suggest_register_params] ?  session[:suggest_register_params].merge(params.permit(:email, :message, :subject)).except('step') : {}
  end

  def index
    @wizard = ModelWizard.new(SuggestRegister.new(merge_from_params), session, params).start
    @suggest_register = @wizard.object
  end

  def create
    @wizard = ModelWizard.new(SuggestRegister.new(merge_from_params), session, params, suggest_register_params).continue
    @suggest_register = @wizard.object

    if @wizard.save
      @zendesk_service = ZendeskFeedback.new
      @response = @zendesk_service.send_feedback(suggest_register_params)
      session[:suggest_register_params] = nil
      redirect_to suggest_register_complete_path
    else
      render :index
    end
  end

  def thanks; end

private

  def suggest_register_params
    return params unless params[:suggest_register]
    params.require(:suggest_register).permit(:current_step, :email, :message, :subject)
  end
end
