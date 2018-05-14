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
    if !@api_user.valid?
      flash.now[:alert] = { title: 'Please fix the errors below', message: @api_user.errors.messages }
      render :new
    else
      response = post_to_endpoint(@api_user)
      if response&.code != nil
        case response.code
        when 422
          flash.now[:alert] = { title: 'Please fix the errors below', message: @api_user.errors.messages }
          JSON.parse(response.body).each { |k, v| @api_user.errors.add(k.to_sym, *v) }
          render :new
        when 201
          @api_key = JSON.parse(response.body)['api_key']
          render :show
        else
          logger.error("API Key POST failed with unexpected response code: #{response.code}")
          flash.now[:alert] = { title: 'Something went wrong' }
          render :new
        end
      else
        flash.now[:alert] = { title: 'Something went wrong' }
        render :new
      end
    end
  end

private

  def post_to_endpoint(user)
    @user = { email: user.is_government == 'yes' ? user.email_gov : user.email_non_gov,
              department: user.department,
              non_gov_use_category: user.non_gov_use_category,
              is_government: user.is_government == 'yes' }
    uri = URI.parse(Rails.configuration.self_service_api_endpoint)
    options = {
      basic_auth: { username: Rails.configuration.self_service_http_auth_username, password: Rails.configuration.self_service_http_auth_password },
      body: @user
    }
    error_message = 'Something went wrong'
    begin
      HTTParty.post(uri, options)
    end
  rescue StandardError => e
    # Fallback for socket errors etc...
    logger.error("API Key POST failed with exception: #{e}")
    flash.now[:alert] = error_message
    nil
  end

  def api_user_params
    params.require(:api_user).permit(
      :email_gov,
      :email_non_gov,
      :department,
      :non_gov_use_category,
      :is_government
    )
  end

  def set_government_orgs_local_authorities
    registers = {
        'government-organisation': 'name',
        'local-authority-eng': 'official-name',
        'local-authority-sct': 'official-name',
        'local-authority-nir': 'official-name',
        'principal-local-authority': 'official-name',
    }

    @government_orgs_local_authorities = registers.map { |k, v|
      Register.find_by(slug: k)&.records&.where(entry_type: 'user')&.current&.map { |r|
        [
            r.data[v], "#{k}:#{r.key}"
        ]
      }
    }.compact.flatten(1)
  end
end
