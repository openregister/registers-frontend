class DownloadUser < ApplicationRecord
  before_save :set_email
  attr_accessor :email_gov, :email_non_gov
  validates :is_government, presence: true
  validates :email_gov, presence: true, if: -> { is_government == 'yes' }
  validates :department, presence: true, if: -> { is_government == 'yes' }
  validates :department, absence: true, if: -> { is_government == 'no' }
  validates :email_non_gov, presence: true, if: -> { is_government == 'no' }
  validates :non_gov_use_category, presence: true, if: -> { is_government == 'no' }
  validates :non_gov_use_category, absence: true, if: -> { is_government == 'yes' }

private

  def set_email
    self.email = [email_non_gov, email_gov].find(&:present?)
  end
end
