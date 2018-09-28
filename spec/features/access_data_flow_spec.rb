require 'rails_helper'

RSpec.feature 'View register', type: :feature do
  before(:all) do
    country_data = File.read('./spec/support/country.rsf')

    stub_request(:get, "https://country.register.gov.uk/download-rsf/0").
    with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'country.register.gov.uk' }).
    to_return(status: 200, body: country_data, headers: {})

    country_update = File.read('./spec/support/country_207.rsf')
    stub_request(:get, "https://country.register.gov.uk/download-rsf/207").
    with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'country.register.gov.uk' }).
    to_return(status: 200, body: country_update, headers: {})

    country_proof = File.read('./spec/support/country_proof.json')
    stub_request(:get, "https://country.register.gov.uk/proof/register/merkle:sha-256").
    with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'country.register.gov.uk' }).
    to_return(body: country_proof)

    government_organisation_data = File.read('./spec/support/government-organisation.rsf')
    stub_request(:get, "https://government-organisation.register.gov.uk/download-rsf/0").
    with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'government-organisation.register.gov.uk' }).
    to_return(status: 200, body: government_organisation_data, headers: {})

    stub_request(:get, "https://government-organisation.register.gov.uk/download-rsf/1002").
    with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'government-organisation.register.gov.uk' }).
    to_return(status: 200, body: "assert-root-hash\tsha-256:f42d8409df99cceb6c92e5b6b2eb24cd51075d1aa23924fcbdbabf57fbc4ab98")

    country = ObjectsFactory.new.create_register('Country', 'Beta')
    government_organisation = ObjectsFactory.new.create_register('government-organisation', 'Beta')
    PopulateRegisterDataInDbJob.perform_now(country)
    PopulateRegisterDataInDbJob.perform_now(government_organisation)
  end

  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  scenario 'shows Access to data correctly' do
    visit('/registers/country')
    expect(page).to have_content('Access the data')
  end

  scenario 'goes to choose how to access correctly' do
    visit('/registers/country')
    click_link('Access the data')

    expect(page).to have_content('Choose how to access the data')
    expect(page).to have_css '.highlight-box', count: 2
    expect(page).to have_css '.highlight-box a', count: 2

    expect(page).to have_content('API')
    expect(page).to have_content('Download')
  end
end
