class DownloadUser < ApplicationRecord
  validates :is_government, presence: true
  validates :email_gov, presence: true, if: -> { is_government == 'yes' }
  validates :department, presence: true, if: -> { is_government == 'yes' }
  validates :department, absence: true, if: -> { is_government == 'no' }
  validates :email_non_gov, presence: true, if: -> { is_government == 'no' }
  validates :non_gov_use_category, presence: true, if: -> { is_government == 'no' }
  validates :non_gov_use_category, absence: true, if: -> { is_government == 'yes' }
end
