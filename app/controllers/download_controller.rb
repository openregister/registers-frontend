class DownloadController < ApplicationController
  include DownloadHelpers
  include FormHelpers
  before_action :set_register
  before_action :set_government_orgs_local_authorities
  helper_method :link_to_format

  def index
    @download = DownloadUser.new
  end

  def create
    @download = DownloadUser.new(download_user_params)
    @download.email = [@download.email_non_gov, @download.email_gov].find(&:present?)
    if @download.save
      redirect_to register_download_success_path(@register.slug)
    else
      render :index
    end
  end

  def success; end

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
