require 'net/http'
require 'uri'
require 'json'
require 'httparty'

class ApiUsersController < ApplicationController
  include FormHelpers
  before_action :set_government_orgs_local_authorities

  def new
    @api_user = ApiUser.new
  end

  def create
    @api_user = ApiUser.new(set_is_government_boolean(api_user_params))
    if !@api_user.valid?
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

  def api_user_params
    params.require(:api_user).permit(
      :email_gov,
      :email_non_gov,
      :department,
      :non_gov_use_category,
      :is_government
    )
  end
end
