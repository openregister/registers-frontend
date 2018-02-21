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

    gov_org_data = File.read('./spec/support/government_organisation.rsf')
    stub_request(:get, "https://government-organisation.register.gov.uk/download-rsf/0").
    with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'government-organisation.register.gov.uk' }).
    to_return(status: 200, body: gov_org_data, headers: {})

    RegistersClientWrapper.class_variable_set(:@@registers_client, RegistersClient::RegisterClientManager.new(cache_duration: 600))

    country = ObjectsFactory.new.create_register('Country', 'Beta', 'D587')
    gov_org = ObjectsFactory.new.create_register('Government organisation', 'Beta', 'D587')
    PopulateRegisterDataInDbJob.perform_now(country)
    PopulateRegisterDataInDbJob.perform_now(gov_org)
  end

  scenario 'view and sort a register' do
    visit '/'
    expect(page).to have_content('Registers ready to use')
    click_link('Country')
    expect(page).to have_content('Afghanistan')
    click_link('name')
    expect(page).to have_content('Zimbabwe')
  end

  scenario 'filter a register' do
    visit('/registers/country')
    choose('Archived records')
    click_button('Search', match: :first)
    expect(page).to have_current_path(/status=archived/)
    expect(page).to have_content('USSR')
  end

  scenario 'view updates' do
    visit('/registers/country/updates')
    first_update = find('h3', match: :first)
    expect(first_update.text).to eq('CI')
    expect(first_update.sibling('table')).to have_content("The Republic of Côte D’Ivoire")
    expect(first_update.sibling('table')).to have_content("The Republic of Cote D'Ivoire")
  end

  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end
end
