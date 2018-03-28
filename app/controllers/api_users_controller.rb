require 'net/http'
require 'uri'
require 'json'

class ApiUsersController < ApplicationController
  before_action :set_government_organisations

  def new
    @api_user = ApiUser.new
  end

  def create
    @api_user = ApiUser.new(api_user_params)
    if @api_user.valid?
      post_to_endpoint(@api_user)
      redirect_to root_path
    else
      render :new
    end
  end

  def post_to_endpoint(user)
    @user = { email: user.email, department: user.department, service: user.service }
    Net::HTTP.post_form(URI(Rails.configuration.self_service_api_endpoint), @user)
  end

private

  def api_user_params
    params.require(:api_user).permit(
      :email,
      :department,
      :service
    )
  end

  def set_government_organisations
    @government_organisations = Register.find_by(slug: 'government-organisation')
                                        .records
                                        .where(entry_type: 'user')
                                        .current
  end
end
