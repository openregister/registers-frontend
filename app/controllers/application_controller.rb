class ApplicationController < Spina::ApplicationController
  include Spina::Frontend

  is_trial_domain = Rails.env.production? && JSON.parse(ENV.fetch('VCAP_APPLICATION'))['uris'].include?('registers-trial.service.gov.uk')
  http_basic_authenticate_with name: Rails.configuration.http_auth_username, password: Rails.configuration.http_auth_password if is_trial_domain

  protect_from_forgery with: :exception
end
