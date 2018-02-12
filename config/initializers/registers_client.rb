class RegistersClientWrapper
  @@registers_client ||= RegistersClient::RegisterClientManager.new(cache_duration: 600) # rubocop:disable Style/ClassVars
  def self.registers_client
    @@registers_client
  end
end

RegistersClientWrapper.registers_client
