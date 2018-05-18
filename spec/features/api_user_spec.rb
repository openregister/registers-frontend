require 'rails_helper'
require 'spec_helper'

RSpec.feature 'API Key Registration', type: :feature do
  before(:all) do
    government_organisation_data = File.read('./spec/support/government-organisation.rsf')
    stub_request(:get, "https://government-organisation.register.gov.uk/download-rsf/0").
    with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'government-organisation.register.gov.uk' }).
    to_return(status: 200, body: government_organisation_data, headers: {})

    stub_request(:get, "https://government-organisation.register.gov.uk/download-rsf/1002").
    with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'government-organisation.register.gov.uk' }).
    to_return(status: 200, body: "assert-root-hash\tsha-256:f42d8409df99cceb6c92e5b6b2eb24cd51075d1aa23924fcbdbabf57fbc4ab98", headers: {})
    government_organisation = ObjectsFactory.new.create_register('government-organisation', 'Beta', 'D587')
    PopulateRegisterDataInDbJob.perform_now(government_organisation)
  end

  scenario 'valid submission generates API key' do
    visit '/api_users/new'
    expect(page).to have_content('Create your API key')
    choose('Yes')
    select 'Government Digital Service', from: 'Which government organisation do you work for?'
    fill_in('api_user_email_gov', with: 'test@example.com')
  end
end
