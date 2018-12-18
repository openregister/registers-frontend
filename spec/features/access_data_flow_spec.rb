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

  scenario 'shows download and API options correctly' do
    visit('/registers/country')
    expect(page).to have_css '.highlight-box', count: 2
    expect(page).to have_content('Download the data')
    expect(page).to have_content('Use the API')
  end

  scenario 'the states for all pages in API flow are 200' do
    visit('/registers/country')
    expect(page.status_code).to eq(200)

    click_link('Use the API')
    expect(page.status_code).to eq(200)

    click_link('Skip this step')
    expect(page.status_code).to eq(200)
  end

  scenario 'the states for all pages in download flow are 200' do
    visit('/registers/country')
    expect(page.status_code).to eq(200)

    click_link('Download the data')
    expect(page.status_code).to eq(200)

    click_link('Skip this step')
    expect(page.status_code).to eq(200)
  end

  scenario 'goes to questionnaire correctly when download option chosen' do
    visit('/registers/country')
    click_link('Download the data')

    expect(page).to have_content('Before you download the data')
    expect(page).to have_content('Help us improve GOV.UK Registers')

    expect(page).to have_content('What part of government are you working for?')
    expect(page).to have_content('What are you using registers for?')
    expect(page).to have_content('Yes')
    expect(page).to have_content('Building a service')
    expect(page).to have_content('For data analysis or reporting')
    expect(page).to have_content('Other')
    expect(page).to have_content('No')
    expect(page).to have_content('Commercial use')
    expect(page).to have_content('Non-commercial use')
    expect(page).to have_content('Personal use')

    click_button('Submit')
  end

  scenario 'goes to questionnaire correctly when API option chosen' do
    visit('/registers/country')
    click_link('Use the API')
    expect(page).to have_content('Before you use the API')
    expect(page).to have_content('Help us improve GOV.UK Registers')
    expect(page).to have_content('What part of government are you working for?')
    expect(page).to have_content('What are you using registers for?')
  end

  scenario 'goes to download page correctly when questionnaire is skipped' do
    visit('/registers/country')
    click_link('Download the data')
    click_link('Skip this step')
    expect(page).to have_content('Download the data')
  end

  scenario 'goes to download page correctly when questionnaire is submitted' do
    visit('/registers/country')
    click_link('Download the data')
    click_button('Submit') # No JavaScript, so the empty form should just submit and go to the next page.
    expect(page).to have_content('Download the data')
  end

  scenario "download link skips the questionnaire if it's already been seen" do
    visit('/registers/country')
    click_link('Download the data')
    click_link('Skip this step')
    visit('/registers/country')
    click_link('Download the data')
    expect(page).to have_content('Download the data')
    expect(page).to have_content('ODS (Excel compatible)')
    expect(page).to have_content('CSV')
  end

  scenario 'goes to API page correctly when questionnaire is skipped' do
    visit('/registers/country')
    click_link('Use the API')
    click_link('Skip this step')
    expect(page).to have_content('Use the API')
  end

  scenario 'goes to API page correctly when questionnaire is submitted' do
    visit('/registers/country')
    click_link('Use the API')
    click_button('Submit') # No JavaScript, so the empty form should just submit and go to the next page.
    expect(page).to have_content('Use the API')
  end

  scenario "API access link skips the questionnaire if it's already been seen" do
    visit('/registers/country')
    click_link('Use the API')
    click_link('Skip this step')
    visit('/registers/country')
    click_link('Use the API')
    expect(page).to have_content('Use the API')
    expect(page).to have_content('register.gov.uk/records.json?page-size=5000')
  end
end
