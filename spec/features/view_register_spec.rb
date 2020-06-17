require 'rails_helper'

RSpec.feature 'View register', type: :feature do
  before(:all) do
    country_data = File.read('./spec/support/country.rsf')
    industrial_classification_data = File.read('./spec/support/industrial-classification-2003.rsf')

    stub_request(:get, "https://country.register.gov.uk/download-rsf/0").
    with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'country.register.gov.uk' }).
    to_return(status: 200, body: country_data, headers: {})

    stub_request(:get, "https://industrial-classification-2003.cloudapps.digital/download-rsf/0").
    with(headers: {
      'Accept' => '*/*',
      'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Host' => 'industrial-classification-2003.cloudapps.digital',
      }).
    to_return(status: 200, body: industrial_classification_data)

    government_organisation_data = File.read('./spec/support/government-organisation.rsf')
    stub_request(:get, "https://government-organisation.register.gov.uk/download-rsf/0").
    with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'government-organisation.register.gov.uk' }).
    to_return(status: 200, body: government_organisation_data, headers: {})

    country = ObjectsFactory.new.create_register('Country', 'Beta')
    industrial_classification = ObjectsFactory.new.create_register('industrial classification 2003', 'Discovery')
    government_organisation = ObjectsFactory.new.create_register('government-organisation', 'Beta')
    ForceFullRegisterDownloadJob.perform_now(country)
    ForceFullRegisterDownloadJob.perform_now(industrial_classification)
    ForceFullRegisterDownloadJob.perform_now(government_organisation)
  end

  scenario 'search for a register' do
    visit('/registers')
    fill_in('q', with: 'country')
    click_button('Search', match: :first)
    expect(page).to have_content('Country')
  end

  scenario 'view a register' do
    visit('/registers/country')
    first_row_item = find('#records-tbody tr td', match: :first)
    expect(first_row_item).to have_content("AF")
    expect(page).to have_content('Country register')
    expect(page).to have_content('Afghanistan')
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
    title = 'UK Standard Industrial Classification of Economic Activities 2003 register'
    expect(find('h1')).to have_content(title)
    expect(page.title).to have_content(title)
  end

  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end
end
