RSpec.shared_context 'country stubs', shared_context: :metadata do
  before(:all) do
    country_data = File.read('./spec/support/country.rsf')
    country_proof = File.read('./spec/support/country_proof.json')
    stub_request(:get, 'https://country.register.gov.uk/download-rsf/0')
    .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate' })
    .to_return(status: 200, body: country_data, headers: {})

    stub_request(:get, "https://country.register.gov.uk/proof/register/merkle:sha-256").
    with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'country.register.gov.uk' }).
    to_return(status: 200, body: country_proof, headers: {})
  end

  def populate_db
    register = ObjectsFactory.new.create_register('country', 'Beta')
    PopulateRegisterDataInDbJob.perform_now(register)
  end

  RSpec.configure do |rspec|
    rspec.include_context 'country stubs', include_shared: true
  end
end
