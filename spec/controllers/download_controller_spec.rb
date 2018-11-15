require 'rails_helper'

RSpec.describe DownloadController, type: :controller do
  before(:all) do
    country_data = File.read('./spec/support/country.rsf')
    country_proof = File.read('./spec/support/country_proof.json')
    ObjectsFactory.new.create_register('country', 'Beta')

    # RSF stubs
    stub_request(:get, 'https://country.register.gov.uk/download-rsf/0')
    .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate' })
    .to_return(status: 200, body: country_data, headers: {})

    stub_request(:get, "https://country.register.gov.uk/proof/register/merkle:sha-256").
    with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'country.register.gov.uk' }).
    to_return(status: 200, body: country_proof, headers: {})

    Register.find_each do |register|
      PopulateRegisterDataInDbJob.perform_now(register)
    end
  end

  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  describe 'ODS request' do
    before(:each) do
      get :download_ods, params: { register_id: 'country' }
    end

    it 'has a 200 response code' do
      expect(response.status).to eq(200)
    end

    it 'has the ODS content type' do
      get :download_ods, params: { register_id: 'country' }
      expect(response.content_type).to eq('application/vnd.oasis.opendocument.spreadsheet')
      expect(response.headers['Content-Transfer-Encoding']).to eq('binary')
      expect(response.headers['Content-Disposition']).to eq('attachment; filename=country.ods')
      expect(response.body.length).to be > 100
    end
  end
end
