class DownloadController < ApplicationController
  before_action :set_government_orgs_local_authorities

  def index
    @download = Download.new
  end

  def create
    @download = Download.new(download_params)
    if @download.valid?
      # DO SOMETHING
    else
      # DO SOMETHING
    end
  end

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
