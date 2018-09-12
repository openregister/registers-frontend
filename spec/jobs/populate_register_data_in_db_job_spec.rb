require 'rails_helper'

RSpec.configure do |config|
  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

RSpec.describe PopulateRegisterDataInDbJob, type: :job do
  let!(:register) { ObjectsFactory.new.create_register('country', 'beta') }

  before do
    country_data = File.read('./spec/support/country.rsf')
    stub_request(:get, "https://country.register.gov.uk/download-rsf/0").
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'country.register.gov.uk' }).
      to_return(status: 200, body: country_data, headers: {})

    country_proof = File.read('./spec/support/country_proof.json')
    country_proof_update = File.read('./spec/support/country_proof_update.json')
    stub_request(:get, "https://country.register.gov.uk/proof/register/merkle:sha-256").
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'country.register.gov.uk' }).
      to_return({ body: country_proof }, body: country_proof_update)

    PopulateRegisterDataInDbJob.perform_now(register)
  end

  it 'interprets end_date to second precision by using the start of the time period' do
    expect(Record.find_by(key: 'DD').end_date).to eq(Time.utc(1990, 10, 2, 0, 0, 0))
  end

  it 'leaves end_date null if end-date is missing' do
    expect(Record.find_by(key: 'GB').end_date).to be_nil
  end

  it 'populates previous entry number from current RSF' do
    expect(Entry.where(key: 'CZ').order(entry_number: :desc).first[:previous_entry_number]).to eq(52)
  end

  context 'when incrementally updating data' do
    before do
      country_update = File.read('./spec/support/country_update.rsf')
      stub_request(:get, "https://country.register.gov.uk/download-rsf/207").
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'country.register.gov.uk' }).
        to_return(status: 200, body: country_update, headers: {})

      PopulateRegisterDataInDbJob.perform_now(register)
    end

    it 'retains existing entries' do
      expect(Entry.where(key: 'CI').first.data['citizen-names']).to eq('Citizen of the Ivory Coast')
    end

    it 'adds entries to the existing register' do
      expect(Register.count).to eq(1)
      expect(Entry.where(register_id: Register.find_by(name: 'country').id).count).to eq(220)
      expect(Entry.where(key: 'CI').last.data['citizen-names']).to eq('Citizen of the Ivory Coast EDIT')
    end

    it 'populates the previous entry number of the new entry' do
      expect(Entry.where(key: 'CI').order(entry_number: :desc).first[:previous_entry_number]).to eq(207)
    end

    it 'updates the record in the existing register' do
      expect(Record.find_by(key: 'CI').data['citizen-names']).to eq('Citizen of the Ivory Coast EDIT')
    end
  end
end
