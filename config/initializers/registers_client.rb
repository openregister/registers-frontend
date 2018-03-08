class RegistersClientWrapper
  @@registers_client ||= RegistersClient::RegisterClientManager.new # rubocop:disable Style/ClassVars
  def self.registers_client
    @@registers_client
  end
end

RegistersClientWrapper.registers_client
