class RegisterRecordsDownloader
  class DownloadError < StandardError; end

  def initialize(register, api_key: Rails.configuration.try(:user_download_api_key))
    @register = register
    @api_key = api_key
  end

  def download_format(format)
    uri = "#{register.url}/records.#{format}?page-size=5000"
    headers = {}
    headers['Authorization'] = api_key if api_key.present?

    response = HTTParty.get(uri, headers: headers)
    if response.code == 200
      response.body
    else
      raise DownloadError.new("#{response.code}: #{response.message}")
    end
  end

private

  attr_reader :register
  attr_reader :api_key
end
