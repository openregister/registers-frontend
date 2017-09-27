CarrierWave.configure do |config|
  if Rails.env.production?
    config.fog_credentials = {
      provider:               'AWS',
      region:                 Rails.application.secrets.aws_region,
      aws_access_key_id:      Rails.application.secrets.aws_key,
      aws_secret_access_key:  Rails.application.secrets.aws_secret
    }
    config.storage = :fog
    config.fog_directory  = Rails.application.secrets.aws_bucket
    config.fog_public     = true
    config.fog_attributes = { 'Cache-Control' => 'max-age=315576000' }
  else
    config.storage = :file
  end
end
