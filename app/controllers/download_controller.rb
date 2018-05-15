module DownloadHelper
  include ActionView::Helpers::UrlHelper
  def link_to_format(format)
    link_to(format.upcase, "#{@register.url}/records.#{format}?page-size=5000")
  end
end

class DownloadController < ApplicationController
  include DownloadHelper
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
      flash.now[:alert] = { title: 'Please fix the errors below', message: @download.errors.messages }
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

  def set_government_orgs_local_authorities
    registers = {
        'government-organisation': 'name',
        'local-authority-eng': 'official-name',
        'local-authority-sct': 'official-name',
        'local-authority-nir': 'official-name',
        'principal-local-authority': 'official-name',
    }

    @government_orgs_local_authorities = registers.map { |k, v|
      Register.find_by(slug: k)&.records&.where(entry_type: 'user')&.current&.map { |r|
        [
            r.data[v], "#{k}:#{r.key}"
        ]
      }
    }.compact.flatten(1)
  end
end
