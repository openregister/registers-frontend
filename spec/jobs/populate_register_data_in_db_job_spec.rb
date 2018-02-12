require 'rails_helper'

RSpec.configure do |config|
  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

RSpec.describe PopulateRegisterDataInDbJob, type: :job do
  before(:all) do
    country_data = File.read('./spec/support/country.rsf')
    stub_request(:get, "https://country.register.gov.uk/download-rsf/0").
    with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'country.register.gov.uk' }).
    to_return(status: 200, body: country_data, headers: {})

    country_update = File.read('./spec/support/country_update.rsf')
    stub_request(:get, "https://country.register.gov.uk/download-rsf/207").
    with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'country.register.gov.uk' }).
    to_return(status: 200, body: country_update, headers: {})

    country_proof = File.read('./spec/support/country_proof.json')
    country_proof_update = File.read('./spec/support/country_proof_update.json')
    stub_request(:get, "https://country.register.gov.uk/proof/register/merkle:sha-256").
    with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'country.register.gov.uk' }).
    to_return({ body: country_proof }, body: country_proof_update)

    RegistersClientWrapper.class_variable_set(:@@registers_client, RegistersClient::RegisterClientManager.new(cache_duration: 600))

    ObjectsFactory.new.create_register('country', 'beta', 'Ministry of Justice')
    Register.find_each do |register|
      PopulateRegisterDataInDbJob.perform_now(register)
    end
  end

  describe 'populate register data job' do
    it 'incrementally updates data' do
      expect(Register.count).to eq(1)
      expect(Entry.where(register_id: Register.find_by(name: 'country').id).count).to eq(220)
      expect(Record.find_by(key: 'CI').data['citizen-names']).to eq('Citizen of the Ivory Coast EDIT')
      expect(Entry.where(key: 'CI').last.data['citizen-names']).to eq('Citizen of the Ivory Coast EDIT')
    end

    it 'retains existing entries' do
      expect(Entry.where(key: 'CI').first.data['citizen-names']).to eq('Citizen of the Ivory Coast')
    end

    it 'populates previous entry number from current RSF' do
      expect(Entry.where(key: 'CZ').order(entry_number: :desc).first[:previous_entry_number]).to eq(52)
    end

    it 'populates previous entry number from database' do
      expect(Entry.where(key: 'CI').order(entry_number: :desc).first[:previous_entry_number]).to eq(207)
    end
  end

  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end
end
