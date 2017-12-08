require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require "registers_client"
require "cf-app-utils"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RegisterStatus
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    if ENV.key?('VCAP_SERVICES')
      cups_env = CF::App::Credentials.find_by_service_name(Rails.configiration.cups_environment_variables_service_name)
      if cups_env.present?
        cups_env.each { |k, v| ENV[k] = v }
      end
    end
  end
end
