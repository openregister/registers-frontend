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

  def download_ods
    #ods_download_to_ga
    headers = register.fields_array
    data = register.records.where(entry_type: 'user').find_each.map do |r|
      headers.map { |f| r.data[f] }
    end
    SpreadsheetArchitect.to_ods(headers: headers, data: data)
  end

private

  def ods_download_to_ga
    params = {
      v: 1,
      t: 'pageview',
      tid: Rails.configuration.x.google_analytics.api_tracking_id,
      cid: SecureRandom.uuid,
      aip: 1,
      ni: 1,
      dl: register.url + Rails.application.routes.url_helpers.register_download_ods_path(register.slug),
      cd2: 'N/A',
      cd4: 'Registers-Frontend-Downloads',
      cd5: 'API'
    }
    HTTParty.post('https://www.google-analytics.com/collect', body: params)
  end

  attr_reader :register
  attr_reader :api_key
end
