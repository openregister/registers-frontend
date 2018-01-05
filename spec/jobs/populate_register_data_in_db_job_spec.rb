require 'rails_helper'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

RSpec.describe PopulateRegisterDataInDbJob, type: :job do
  before(:each) do
    country_data = File.read('./spec/support/country.rsf')
    stub_request(:get, "https://country.beta.openregister.org/download-rsf/0").
    with(headers: { 'Accept'=>'*/*', 'Accept-Encoding'=>'gzip, deflate', 'Host'=>'country.beta.openregister.org' }).
    to_return(status: 200, body: country_data, headers: {})

    country_update = File.read('./spec/support/country_update.rsf')
    stub_request(:get, "https://country.beta.openregister.org/download-rsf/207").
    with(headers: { 'Accept'=>'*/*', 'Accept-Encoding'=>'gzip, deflate', 'Host'=>'country.beta.openregister.org' }).
    to_return(status: 200, body: country_update, headers: {})

    ObjectsFactory.new.create_register('country', 'beta', 'Ministry of Justice')
    PopulateRegisterDataInDbJob.perform_now
  end

  describe 'populate register data job' do
    it 'incrementally updates data' do
      expect(Spina::Register.count).to eq(1)
      expect(Entry.where(spina_register_id: Spina::Register.find_by(name: 'country').id).count).to eq(220)
      expect(Record.find_by(key: 'CI').data['citizen-names']).to eq('Citizen of the Ivory Coast EDIT')
      expect(Entry.where(key: 'CI').last.data['citizen-names']).to eq('Citizen of the Ivory Coast EDIT')
    end

    it 'retains existing entries' do
      expect(Entry.where(key: 'CI').first.data['citizen-names']).to eq('Citizen of the Ivory Coast')
    end
  end
end
