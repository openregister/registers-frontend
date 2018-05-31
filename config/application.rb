require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require "register_client_manager"
require "cf-app-utils"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RegisterStatus
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.active_job.queue_adapter = :delayed_job
    config.exceptions_app = routes


    ActionView::Base.default_form_builder = GovukElementsFormBuilder::FormBuilder

    if ENV.key?('VCAP_SERVICES')
      cups_env = CF::App::Credentials.find_by_service_name('registers-product-site-environment-variables')
      if cups_env.present?
        cups_env.each { |k, v| ENV[k] = v }
      end
    end
  end
end
