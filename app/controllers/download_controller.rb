require 'open-uri'

class DownloadController < ApplicationController
  include FormHelpers
  include ActionView::Helpers::UrlHelper

  before_action :set_register
  before_action :set_number_of_steps
  before_action :set_government_organisations, only: :new
  helper_method :government_orgs_local_authorities

  def index
    @custom_dimension_2 = "#{@register.name} - download"
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
      @custom_dimension_2 = "#{@register.name} - API"
    else
      @next_page = register_download_index_path
      @custom_dimension_2 = "#{@register.name} - download"
    end
  end

  def get_api
    @custom_dimension_2 = "#{@register.name} - API"

    # This is the last point we need to use custom dimension 3. But
    # setting it to `nil` here prevents it from being used in the final page
    # of the flow.
    #
    # Assigning it to a variable, then setting the session to `nil` allows
    # both the use and reset of the custom dimension.
    @custom_dimension_3 = session[:last_seen_registers_stage]
    session[:last_seen_registers_stage] = nil

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

  def set_number_of_steps
    @number_of_steps = cookies[:seen_help_us_improve_questions] ? 2 : 3
  end
end
