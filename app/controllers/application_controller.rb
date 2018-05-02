class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  layout 'application'

  is_trial_domain = Rails.env.production? && JSON.parse(ENV.fetch('VCAP_APPLICATION'))['uris'].include?('registers-trial.service.gov.uk')
  http_basic_authenticate_with name: Rails.configuration.http_auth_username, password: Rails.configuration.http_auth_password if is_trial_domain

private

  def current_user
    @current_user ||= User.where(id: session[:user_id]).first if session[:user_id]
  end
  helper_method :current_user
end
