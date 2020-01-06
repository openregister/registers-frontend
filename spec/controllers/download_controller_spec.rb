require 'rails_helper'
require 'country_stubs'

RSpec.describe DownloadController, type: :controller do
  include_context 'country stubs'
  before(:all) do
    populate_db
  end

  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  describe 'ODS request' do
    before(:each) do
      stub_request(:any, 'https://www.google-analytics.com/collect')
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
