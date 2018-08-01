require 'rails_helper'

RSpec.describe 'handling invalid register exceptions' do
  let!(:country) do
    country = create(
      :register,
      name: 'country',
      register_phase: 'beta',
      authority: 'D587'
    )

    country_data = File.read('./spec/support/country.rsf')
    stub_request(:get, "https://country.register.gov.uk/download-rsf/0").
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'country.register.gov.uk' }).
      to_return(status: 200, body: country_data, headers: {})

    # Populate register with 208 records
    PopulateRegisterDataInDbJob.perform_now(country)

    country
  end

  let(:country_invalid_hash) { File.read('./spec/support/country_invalid_hash.rsf') }

  before do
    country_proof = File.read('./spec/support/country_proof.json')
    country_proof_update = File.read('./spec/support/country_proof_update.json')

    stub_request(:get, "https://country.register.gov.uk/proof/register/merkle:sha-256").
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'country.register.gov.uk' }).
      to_return({ body: country_proof }, body: country_proof_update)
  end

  describe PopulateRegisterDataInDbJob, type: :job do
    it 'runs the redownload register job when the register is invalid' do
      stub_request(:get, "https://country.register.gov.uk/download-rsf/207").
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'country.register.gov.uk' }).
        to_return(status: 200, body: country_invalid_hash, headers: {})

      expect(ForceFullRegisterDownloadJob).to receive(:perform_now)

      PopulateRegisterDataInDbJob.perform_now(country)
    end
  end

  describe ForceFullRegisterDownloadJob, type: :job do
    it 'rolls back and raises an error if the register is invalid' do
      stub_request(:get, "https://country.register.gov.uk/download-rsf/0").
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'country.register.gov.uk' }).
        to_return(status: 200, body: country_invalid_hash, headers: {})

      expect { ForceFullRegisterDownloadJob.perform_now(country) }.to raise_error(InvalidRegisterError, 'Register has been reloaded with different data - root hashes do not match')

      expect(Record.where(register_id: country.id).count).to eq(208)
      expect(Entry.where(register_id: country.id).count).to eq(219)
    end
  end
end
