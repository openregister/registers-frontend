Spina::ApplicationController.class_eval do
  http_basic_authenticate_with name: ENV['HTTP_AUTH_USERNAME'], password: ENV['HTTP_AUTH_PASSWORD'] if Rails.env.production?

  before_action :initialize_client

  def initialize_client
    @registers_client ||= RegistersClient::RegistersClientManager.new(cache_duration: 600)
  end
end
