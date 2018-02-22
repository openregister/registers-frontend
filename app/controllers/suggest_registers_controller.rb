class SuggestRegistersController < ApplicationController
  def index
    @wizard = ModelWizard.new(SuggestRegister, session, params).start
    @suggest_register = @wizard.object
  end

  def create
    @wizard = ModelWizard.new(SuggestRegister, session, params, suggest_register_params).continue
    @suggest_register = @wizard.object

    if @wizard.save
      debugger
      redirect_to root_path
    else
      render :index
    end
  end

  def thanks

  end

  private

  def suggest_register_params
    return params unless params[:suggest_register]
    params.require(:suggest_register).permit(:current_step, :email, :title, :reason)
  end

end
