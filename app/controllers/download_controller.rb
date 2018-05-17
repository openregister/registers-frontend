require 'open-uri'

class DownloadController < ApplicationController
  include FormHelpers
  before_action :set_register
  before_action :set_government_orgs_local_authorities
  helper_method :link_to_format

  def index
    @download = DownloadUser.new
  end

  def create
    @download = DownloadUser.new(set_is_government_boolean(download_user_params))
    if @download.save
      redirect_to register_download_success_path(@register.slug)
    else
      render :index
    end
  end

  def success; end

  def download_json
    data  = open("#{@register.url}/records.json?page-size=5000") {|f| f.read }
    send_data data, type: "application/json; header=present", disposition: "attachment; filename=#{@register.slug}.json"
  end

  def download_csv
    data  = open("#{@register.url}/records.csv?page-size=5000") {|f| f.read }
    send_data data, type: "application/csv; header=present", disposition: "attachment; filename=#{@register.slug}.csv"
  end

private

  def download_user_params
    params.require(:download_user).permit(
      :email_gov,
      :email_non_gov,
      :department,
      :non_gov_use_category,
      :is_government
    )
  end

  def set_register
    @register = Register.find_by_slug!(params[:register_id])
  end
end
