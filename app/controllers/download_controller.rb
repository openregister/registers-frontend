require 'open-uri'

class DownloadController < ApplicationController
  include FormHelpers
  before_action :set_register
  helper_method :link_to_format, :government_orgs_local_authorities

  def index
    @download = DownloadUser.new
  end

  def create
    @download = DownloadUser.new(set_is_government_boolean(download_user_params).merge!(register: params[:register_id]))

    if !@download.valid?
      render :index
    else
      response = post_to_endpoint(@download, 'download_users')
      if response&.code != nil
        case response.code
        when 422
          flash.now[:alert] = { title: 'Please fix the errors below', message: @download.errors.messages }
          JSON.parse(response.body).each { |k, v| @download.errors.add(k.to_sym, *v) }
          render :new
        when 201
          redirect_to register_download_success_path(@register.slug)
        else
          logger.error("Download POST failed with unexpected response code: #{response.code}")
          flash.now[:alert] = { title: 'Something went wrong' }
          render :new
        end
      else
        flash.now[:alert] = { title: 'Something went wrong' }
        render :index
      end
    end
  end

  def success; end

  def download_json
    data = open("#{@register.url}/records.json?page-size=5000", &:read)
    send_data data, type: "application/json; header=present", disposition: "attachment; filename=#{@register.slug}.json"
  end

  def download_csv
    data = open("#{@register.url}/records.csv?page-size=5000", &:read)
    send_data data, type: "application/csv; header=present", disposition: "attachment; filename=#{@register.slug}.csv"
  end

private


  def set_register
    @register = Register.find_by_slug!(params[:register_id])
  end

  def download_user_params
    params.require(:download_user).permit(
      :email_gov,
      :email_non_gov,
      :department,
      :non_gov_use_category,
      :is_government,
      :register
    )
  end
end
