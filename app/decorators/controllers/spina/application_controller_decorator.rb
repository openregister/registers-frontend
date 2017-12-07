Spina::ApplicationController.class_eval do
  before_action :initialize_client

  def initialize_client
    @registers_client ||= RegistersClient::RegistersClientManager.new(cache_duration: 600)
  end
end
