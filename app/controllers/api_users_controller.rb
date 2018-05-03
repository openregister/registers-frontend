require 'net/http'
require 'uri'
require 'json'
require 'httparty'

class ApiUsersController < ApplicationController
  before_action :set_government_orgs_local_authorities

  def new
    @api_user = ApiUser.new
  end

  def create
    @api_user = ApiUser.new(api_user_params)
    if @api_user.valid?
      response = post_to_endpoint(@api_user)
      if response&.code == 201
        @api_key = JSON.parse(response.body)['api_key']
        render :show
      else
        flash.alert = 'Something went wrong'
        logger.error("API Key POST failed with unexpected response code: #{response.code}") if response&.code
        render :new
      end
    end
  end

private

  def post_to_endpoint(user)
    @user = { email: user.email,
              department: user.department,
              service: user.service,
              is_government: user.is_government == 'yes' }
    uri = URI.parse(Rails.configuration.self_service_api_endpoint)
    options = {
      basic_auth: { username: ENV.fetch('SELF_SERVICE_HTTP_AUTH_USERNAME'), password: ENV.fetch('SELF_SERVICE_HTTP_AUTH_PASSWORD') },
      body: @user
    }
    error_message = 'Something went wrong'
    begin
      HTTParty.post(uri, options)
    end
  rescue StandardError => e
    # Fallback for socket errors etc...
    logger.error("API Key POST failed with exception: #{e}")
    flash.alert = error_message
    nil
  end

  def api_user_params
    params.require(:api_user).permit(
      :email,
      :department,
      :service,
      :is_government
    )
  end

  def set_government_orgs_local_authorities
    @government_orgs_local_authorities = Register.find_by(slug: ['government-organisation', 'local-authority-eng', 'local-authority-sct', 'local-authority-nir', 'principal-local-authority'])
                                        .records
                                        .where(entry_type: 'user')
                                        .current
  end
end
