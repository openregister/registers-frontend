require 'rails_helper'

RSpec.feature 'View register', type: :feature do
  before(:all) do
    country_data = File.read('./spec/support/country.rsf')
    industrial_classification_data = File.read('./spec/support/industrial-classification-2003.rsf')

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

    stub_request(:get, "https://industrial-classification-2003.cloudapps.digital/download-rsf/0").
    with(headers: {
      'Accept' => '*/*',
      'Accept-Encoding' => 'gzip, deflate',
      'Host' => 'industrial-classification-2003.cloudapps.digital',
      }).
    to_return(status: 200, body: industrial_classification_data)

    stub_request(:get, "https://industrial-classification-2003.cloudapps.digital/download-rsf/1158").
    with(headers: {
      'Accept' => '*/*',
      'Accept-Encoding' => 'gzip, deflate',
      'Host' => 'industrial-classification-2003.cloudapps.digital'
      }).
    to_return(status: 200, body: "assert-root-hash\tsha-256:2183de14afa34180a48c274e60d06841facf4627afd769b7f4cf8bf4457a3129")

    government_organisation_data = File.read('./spec/support/government-organisation.rsf')
    stub_request(:get, "https://government-organisation.register.gov.uk/download-rsf/0").
    with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'government-organisation.register.gov.uk' }).
    to_return(status: 200, body: government_organisation_data, headers: {})

    stub_request(:get, "https://government-organisation.register.gov.uk/download-rsf/1002").
    with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'government-organisation.register.gov.uk' }).
    to_return(status: 200, body: "assert-root-hash\tsha-256:f42d8409df99cceb6c92e5b6b2eb24cd51075d1aa23924fcbdbabf57fbc4ab98")

    country = ObjectsFactory.new.create_register('Country', 'Beta', 'D587')
    industrial_classification = ObjectsFactory.new.create_register('industrial classification 2003', 'Discovery', 'D587')
    government_organisation = ObjectsFactory.new.create_register('government-organisation', 'Beta', 'D587')
    PopulateRegisterDataInDbJob.perform_now(country)
    PopulateRegisterDataInDbJob.perform_now(industrial_classification)
    PopulateRegisterDataInDbJob.perform_now(government_organisation)
  end

  scenario 'search for a register' do
    visit('/registers')
    fill_in('q', with: 'country')
    click_button('Search', match: :first)
    expect(page).to have_content('Country')
  end

  scenario 'view and sort a register' do
    visit('/registers/country')
    expect(page).to have_content('Country register')
    click_link('Name')
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

  scenario 'view register name' do
    visit('/registers/industrial-classification-2003')
    register_name = 'UK Standard Industrial Classification of Economic Activities 2003 register'
    expect(find('h1')).to have_content(register_name)
    expect(page.title).to have_content(register_name)
  end

  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end
end
