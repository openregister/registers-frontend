@credentials = CF::App::Credentials.find_by_service_name('registers-product-site-environment-variables')
ActionMailer::Base.add_delivery_method :govuk_notify, GovukNotifyRails::Delivery, api_key: @credentials['NOTIFY_API_KEY']
