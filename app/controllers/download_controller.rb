require 'open-uri'

class DownloadController < ApplicationController
  include FormHelpers
  include ActionView::Helpers::UrlHelper

  before_action :set_register
  before_action :set_government_organisations, only: :new
  helper_method :government_orgs_local_authorities

  def index; end

  def success; end

  def help_improve
    @government_organisations = Register.find_by(slug: 'government-organisation')
                                        .records
                                        .where(entry_type: 'user')
                                        .current

    if current_page?(register_help_improve_api_path)
      @next_page = register_use_the_api_path
      @custom_dimension2 = "#{@register.name} - API"
      @heading_caption = 'Before you use the API'
    else
      @next_page = register_download_path
      @custom_dimension2 = "#{@register.name} - download"
      @heading_caption = 'Before you download the data'
    end
  end

  def download
    @custom_dimension2 = "#{@register.name} - download"
    unless cookies[:seen_help_us_improve_questions]
      cookies[:seen_help_us_improve_questions] = {
        value: true,
        expires: 24.hours.from_now
      }
    end
  end

  def api
    @custom_dimension2 = "#{@register.name} - API"
    unless cookies[:seen_help_us_improve_questions]
      cookies[:seen_help_us_improve_questions] = {
        value: true,
        expires: 24.hours.from_now
      }
    end
  end

  def download_csv
    data = RegisterRecordsDownloader.new(@register).download_format('csv')
    send_data data, type: "application/csv; header=present", disposition: "attachment; filename=#{@register.slug}.csv"
  end

  def download_ods
    data = RegisterRecordsDownloader.new(@register).download_ods
    send_data data, type: 'application/vnd.oasis.opendocument.spreadsheet', disposition: "attachment; filename=#{@register.slug}.ods"
  end

private

  def set_register
    @register = Register.find_by_slug!(params[:register_id])
  end
end
