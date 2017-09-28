require 'cf-app-utils'

CarrierWave.configure do |config|
  if Rails.env.production?
    @credentials = CF::App::Credentials.find_by_service_name('registers-product-site-environment-variables')
    config.fog_credentials = {
      provider:               'AWS',
      region:                 @credentials['AWS_REGION'],
      aws_access_key_id:      @credentials['AWS_KEY'],
      aws_secret_access_key:  @credentials['AWS_SECRET']
    }
    config.storage        = :fog
    config.fog_directory  = @credentials['AWS_BUCKET']
    config.fog_public     = true
    config.fog_attributes = { 'Cache-Control' => 'max-age=315576000' }
  else
    config.storage = :file
  end
end
