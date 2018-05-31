require 'net/http'
require 'uri'
require 'json'
require 'httparty'

class ApiUsersController < ApplicationController
  include FormHelpers
  helper_method :government_orgs_local_authorities

  def index
    @api_user = ApiUser.new
    session[:register] = params[:register] if params[:register].present?
  end

  def create
    @api_user = ApiUser.new(api_user_params)
    if !@api_user.valid?
      render :index
    else
      response = post_to_endpoint(@api_user)
      if response&.code != nil
        case response.code
        when 422
          flash.now[:alert] = { title: 'Please fix the errors below', message: @api_user.errors.messages }
          JSON.parse(response.body).each { |k, v| @api_user.errors.add(k.to_sym, *v) }
          render :index
        when 201
          @api_key = JSON.parse(response.body)['api_key']
          @register = Register.find_by(slug: session[:register])
          render :show
          session.delete(:register)
        else
          logger.error("API Key POST failed with unexpected response code: #{response.code}")
          flash.now[:alert] = { title: 'Something went wrong' }
          render :index
        end
      else
        flash.now[:alert] = { title: 'Something went wrong' }
        render :index
      end
    end
  end

private

  def api_user_params
    params.require(:api_user).permit(
      :email_gov,
      :email_non_gov,
      :is_government
    )
  end
end
