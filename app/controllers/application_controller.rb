class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  layout 'application'

  is_trial_domain = Rails.env.production? && JSON.parse(ENV.fetch('VCAP_APPLICATION'))['uris'].include?('registers-trial.service.gov.uk')
  http_basic_authenticate_with name: Rails.configuration.http_auth_username, password: Rails.configuration.http_auth_password if is_trial_domain

private

  def current_user
    @current_user ||= User.where(id: session[:user_id]).first if session[:user_id]
  end

  def remove_cookie_banner(content)
    #  Hot patch to remove the cookie banner before rendering
    cookie_banner_regex = %r{<div id="global-cookie-message">\s*.*\s*<\/div>}
    content.gsub(cookie_banner_regex, '')
  end

  helper_method :current_user, :remove_cookie_banner
end
