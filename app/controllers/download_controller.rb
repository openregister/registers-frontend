class DownloadController < ApplicationController
  include DownloadHelpers
  include FormHelpers
  before_action :set_register
  before_action :set_government_orgs_local_authorities
  helper_method :link_to_format

  def index
    @download = Download.new
  end

  def create
    @download = Download.new(download_params)
    if @download.valid?
      redirect_to register_download_success_path(@register.slug)
    else
      render :index
    end
  end

  def success; end

private

  def download_params
    params.require(:download).permit(
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
