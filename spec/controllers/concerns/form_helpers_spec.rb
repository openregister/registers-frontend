require 'spec_helper'
require 'rails_helper'

describe FormHelpers, type: :helper do
  before(:all) do
    stub_request(:post, "https://registers-selfservice.cloudapps.digital/download").
    with(
      body: "email=test%40gov.uk&is_government=true&register=country&department=government-organisation%3AOT1056",
      headers: {
      'Accept' => '*/*',
      'Authorization' => 'Basic dXNlcm5hbWU6cGFzc3dvcmQ=',
      }
    ).
    to_return(status: 201, body: "", headers: {})
  end

  it 'includes all paramaters when POSTing to selfservice' do
    include helper
    post_to_endpoint(DownloadUser.new(
                       email_gov: 'test@gov.uk',
                       department: 'government-organisation:OT1056',
                       is_government: 'yes',
                       register: 'country'
    ), 'download')

    expect(WebMock).to have_requested(:post, "https://registers-selfservice.cloudapps.digital/download").
    with(body: "email=test%40gov.uk&is_government=true&register=country&department=government-organisation%3AOT1056").once
  end
end
