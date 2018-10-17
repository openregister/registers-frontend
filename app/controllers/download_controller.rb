require 'open-uri'

class DownloadController < ApplicationController
  include FormHelpers
  include ActionView::Helpers::UrlHelper

  before_action :set_register
  before_action :set_number_of_steps
  before_action :set_government_organisations, only: :new
  helper_method :government_orgs_local_authorities

  def index
    @custom_dimension = "#{@register.name} - download"
  end

  def create
    unless cookies[:seen_help_us_improve_questions]
      cookies[:seen_help_us_improve_questions] = {
        value: true,
        expires: 24.hours.from_now
      }
    end
    render :index
  end

  def success; end

  def choose_access
    if cookies[:seen_help_us_improve_questions]
      @next_step_api = register_get_api_path
      @next_step_download = register_download_index_path
    else
      @next_step_api = register_help_improve_api_path;
      @next_step_download = register_help_improve_download_path
    end
  end

  def help_improve
    @government_organisations = Register.find_by(slug: 'government-organisation')
                                        .records
                                        .where(entry_type: 'user')
                                        .current

    if current_page?(register_help_improve_api_path)
      @next_page = register_get_api_path
      @custom_dimension = "#{@register.name} - API"
    else
      @next_page = register_download_index_path
      @custom_dimension = "#{@register.name} - download"
    end
  end

  def get_api
    @custom_dimension = "#{@register.name} - API"
    unless cookies[:seen_help_us_improve_questions]
      cookies[:seen_help_us_improve_questions] = {
        value: true,
        expires: 24.hours.from_now
      }
    end
  end

  def post_api
    redirect_to register_get_api_path(@register.slug)
  end

  def download_json
    data = RegisterRecordsDownloader.new(@register).download_format('json')
    send_data data, type: "application/json; header=present", disposition: "attachment; filename=#{@register.slug}.json"
  end

  def download_csv
    data = RegisterRecordsDownloader.new(@register).download_format('csv')
    send_data data, type: "application/csv; header=present", disposition: "attachment; filename=#{@register.slug}.csv"
  end

private

  def set_register
    @register = Register.find_by_slug!(params[:register_id])
  end

  def set_number_of_steps
    @number_of_steps = cookies[:seen_help_us_improve_questions] ? 2 : 3
  end
end
