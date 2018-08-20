require 'open-uri'

class DownloadController < ApplicationController
  include FormHelpers
  before_action :set_register
  helper_method :government_orgs_local_authorities

  def index
    if (cookies[:rather_not_say])
      @number_of_steps = 2
    else
      @number_of_steps = 3
    end
  end

  def create
    @download = DownloadUser.new(register: params[:register_id])
    if (cookies[:rather_not_say])
      @number_of_steps = 2
    else
      @number_of_steps = 3
    end

    if !@download.valid?
      if (!cookies[:rather_not_say])
        cookies[:rather_not_say] = {
          :value => true,
          :expires => 1.week.from_now # TOO: confirm cookie length
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
    if (cookies[:rather_not_say])
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
    if (request.fullpath.match(/api$/))
      @next_page = register_get_api_path(@register.slug)
    else
      @next_page = register_path(@register.slug) + '/download'
    end
  end

  def get_api
    if (cookies[:rather_not_say])
      @number_of_steps = 2
    else
      @number_of_steps = 3
      cookies[:rather_not_say] = {
        :value => true,
        :expires => 1.week.from_now
      }
    end
  end
  
  def post_api
    @cookies = false
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

  def download_user_params
  end
end
