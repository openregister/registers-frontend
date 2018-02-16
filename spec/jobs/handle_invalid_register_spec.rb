require 'rails_helper'

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

      RegistersClientWrapper.class_variable_set(:@@registers_client, RegistersClient::RegisterClientManager.new(cache_duration: 600))
    end

    it 'throws exception when register invalid and deletes records and entries' do
      country = ObjectsFactory.new.create_register('country', 'beta', 'Ministry of Justice')
      expect { PopulateRegisterDataInDbJob.perform_now(country) }.to raise_error(PopulateRegisterDataInDbJob::Exceptions::FrontendInvalidRegisterError, 'Register has been reloaded with different data - root hashes do not match')
      expect(Record.where(register_id: country.id).count).to equal(0)
      expect(Entry.where(register_id: country.id).count).to equal(0)
    end
  end

  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end
end
