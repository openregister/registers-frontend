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
      response = post_to_endpoint(@api_user)
      if response.is_a? Net::HTTPCreated
        @api_key = JSON.parse(response.body)['api_key']
        render :show
      else
        flash[:errors] = 'Something went wrong'
        render :new
      end
    end
  end

private

  def post_to_endpoint(user)
    @user = { email: user.email, department: user.department, service: user.service }
    uri = URI.parse(Rails.configuration.self_service_api_endpoint)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')

    http.start do |http_start|
      request = Net::HTTP::Post.new(uri.request_uri)
      request.basic_auth(ENV['SELF_SERVICE_HTTP_AUTH_USERNAME'], ENV['SELF_SERVICE_HTTP_AUTH_PASSWORD'])
      request.set_form_data(@user)
      http_start.request(request)
    end
  end

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
