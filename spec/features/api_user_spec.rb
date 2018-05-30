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
    to_return(status: 200, body: "assert-root-hash\tsha-256:f42d8409df99cceb6c92e5b6b2eb24cd51075d1aa23924fcbdbabf57fbc4ab98")
    government_organisation = ObjectsFactory.new.create_register('government-organisation', 'Beta', 'D587')
    PopulateRegisterDataInDbJob.perform_now(government_organisation)

    stub_request(:post, "https://registers-selfservice.cloudapps.digital/users").
    with(
      body: "email=test%40example.com&department=government-organisation%3AOT1056&is_government=true",
      headers: {
      'Accept' => '*/*',
      'Authorization' => 'Basic dXNlcm5hbWU6cGFzc3dvcmQ=',
      }
).to_return(
  status: 201, body: "{\"email\":\"test@example.com\",\"non_gov_use_category\":null,\"department\":\"government-organisation:PB1202\",\"api_key\":\"TEST-API-KEY\",\"is_government\":true}"
)
  end

  before(:each) do
    visit '/create-api-key'
  end

  scenario 'valid submission generates API key' do
    expect(page).to have_content('Create your API key')
    choose('Yes')
    select 'Government Digital Service', from: 'Which government organisation do you work for?'
    fill_in('api_user_email_gov', with: 'test@example.com')
    first(:css, 'input[data-link-name="new_api_user_submit"]').click
    expect(page).to have_content('Your API key')
    expect(page).to have_content('TEST-API-KEY')
  end

  scenario 'invalid submission shows user errors' do
    first(:css, 'input[data-link-name="new_api_user_submit"]').click
    expect(page).to have_content('Select if you work for government or not')
    expect(page).to have_content('Enter your email address')
  end

  scenario 'invalid email shows user error' do
    choose('Yes')
    select 'Government Digital Service', from: 'Which government organisation do you work for?'
    fill_in('api_user_email_gov', with: 'foo@bar')
    first(:css, 'input[data-link-name="new_api_user_submit"]').click
    expect(page).to have_content('Enter a valid email addres')
  end
end
