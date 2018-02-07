require 'rails_helper'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  # config.around(:each) do |example|
  #   DatabaseCleaner.cleaning do
  #     example.run
  #   end
  # end
end

RSpec.describe PopulateRegisterDataInDbJob, type: :job do
  describe 'handle invalid register exception' do
    before(:all) do
      country_data = File.read('./spec/support/country.rsf')
      stub_request(:get, "https://country.register.gov.uk/download-rsf/0").
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'country.register.gov.uk' }).
      to_return(status: 200, body: country_data, headers: {})

      country_invalid_hash = File.read('./spec/support/country_invalid_hash.rsf')
      stub_request(:get, "https://country.register.gov.uk/download-rsf/207").
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'country.register.gov.uk' }).
      to_return(status: 200, body: country_invalid_hash, headers: {})

      country_proof = File.read('./spec/support/country_proof.json')
      country_proof_update = File.read('./spec/support/country_proof_update.json')
      stub_request(:get, "https://country.register.gov.uk/proof/register/merkle:sha-256").
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'country.register.gov.uk' }).
      to_return({ body: country_proof }, body: country_proof_update)

      @@registers_client = RegistersClient::RegisterClientManager.new(cache_duration: 600) # rubocop:disable Style/ClassVars
    end



    it 'deletes entries and records when register invalid' do
      country = ObjectsFactory.new.create_register('country', 'beta', 'Ministry of Justice')
      PopulateRegisterDataInDbJob.perform_now(country)
    end
  end


  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end
end
