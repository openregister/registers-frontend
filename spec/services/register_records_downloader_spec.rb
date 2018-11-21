require 'rails_helper'

RSpec.describe RegisterRecordsDownloader do
  let(:url) { 'https://country.register.gov.uk' }
  let(:register) { create(:register, url: url) }
  let(:downloader) { RegisterRecordsDownloader.new(register) }
  let(:csv) { "c,s,v\n,foo,bar,baz" }
  it "fetches CSV" do
    stub_request(:get, url + "/records.csv?page-size=5000").to_return(
      body: csv
    )

    response = downloader.download_format("csv")
    expect(response).to eq(csv)
  end

  it "raises DownloadError on non-200 responses" do
    stub_request(:get, url + "/records.csv?page-size=5000").to_return(
      status: 500
    )

    expect { downloader.download_format('csv') }.to raise_error(RegisterRecordsDownloader::DownloadError)
  end

  it "passes an API key if set" do
    downloader_with_key = RegisterRecordsDownloader.new(register, api_key: 'foo')
    download_url = url + "/records.csv?page-size=5000"

    stub_request(:get, download_url).to_return(
      body: csv
    )

    downloader_with_key.download_format('csv')

    expect(WebMock).to have_requested(:get, download_url).with(
      headers: { 'Authorization' => 'foo' }
    )
  end
end
