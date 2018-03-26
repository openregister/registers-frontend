class ApiUsersController < ApplicationController
  before_action :set_government_organisations, only: :new

  def new
    @api_user = ApiUser.new
  end

  def create
    @api_user = ApiUser.new(api_user_params)
    if @api_user.valid?
      redirect_to @api_user, notice: 'New API key was successfully created.'
      NotifyMailer.api_key_confirmation(@api_user).deliver_now
      NotifyMailer.new_api_key_request(@api_user).deliver_now
    else
      render :new
    end
  end

private

  def api_user_params
    params.require(:api_user).permit(
      :email,
      :department,
      :service,
      :api_key
    )
  end

  def set_government_organisations
    @government_organisations = Register.find_by(slug: 'government-organisation')
                                        .records
                                        .where(entry_type: 'user')
                                        .current
  end
end
