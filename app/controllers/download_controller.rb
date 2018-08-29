require 'open-uri'

class DownloadController < ApplicationController
  include FormHelpers
  before_action :set_register
  before_action :set_government_organisations, only: :new
  helper_method :government_orgs_local_authorities

  def index
    @number_of_steps = cookies[:seen_help_us_improve_questions] ? 2 : 3
    @custom_dimension = @register.slug.tr('-', ' ') + ' - download'
  end

  def create
    @download = DownloadUser.new(register: params[:register_id])
    @number_of_steps = cookies[:seen_help_us_improve_questions] ? 2 : 3

    if !@download.valid?
      if !cookies[:seen_help_us_improve_questions]
        cookies[:seen_help_us_improve_questions] = {
          value: true,
          expires: 2.weeks.from_now
        }
      end

      render :index
    else
      response = post_to_endpoint(@download, 'download_users')
      if response&.code != nil
        case response.code
        when 422
          flash.now[:alert] = { title: 'Please fix the errors below', message: @download.errors.messages }
          JSON.parse(response.body).each { |k, v| @download.errors.add(k.to_sym, *v) }
          render :index
        when 201
          redirect_to register_download_success_path(@register.slug)
        else
          logger.error("Download POST failed with unexpected response code: #{response.code}")
          flash.now[:alert] = { title: 'Something went wrong' }
          render :index
        end
      else
        flash.now[:alert] = { title: 'Something went wrong' }
        render :index
      end
    end
  end

  def success; end

  def choose_access
    if cookies[:seen_help_us_improve_questions]
      @number_of_steps = 2
      @next_step_api = register_get_api_path(@register.slug)
      @next_step_download = register_path(@register.slug) + '/download'
    else
      @number_of_steps = 3
      @next_step_api = register_help_improve_api_path(@register.slug);
      @next_step_download = register_help_improve_download_path(@register.slug)
    end
  end

  def help_improve
    @government_organisations = Register.find_by(slug: 'government-organisation')
                                        .records
                                        .where(entry_type: 'user')
                                        .current
    if request.fullpath.match?(/api$/)
      @next_page = register_get_api_path(@register.slug)
      @custom_dimension = @register.slug.tr('-', ' ') + ' - api'
    else
      @next_page = register_path(@register.slug) + '/download'
      @custom_dimension = @register.slug.tr('-', ' ') + ' - download'
    end
  end

  def get_api
    @custom_dimension = @register.slug.tr('-', ' ') + ' - api'
    if cookies[:seen_help_us_improve_questions]
      @number_of_steps = 2
    else
      @number_of_steps = 3
      cookies[:seen_help_us_improve_questions] = {
        value: true,
        expires: 2.weeks.from_now
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

  def download_user_params; end
end
