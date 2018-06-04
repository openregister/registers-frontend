class DownloadUser
  include ActiveModel::Model
  include ActiveModel::Translation
  include FormConcerns
  attr_accessor :email_gov, :email_non_gov, :non_gov_use_category, :department, :is_government, :register

  validates :email_gov, presence: true, email: true, if: -> { is_government_boolean == true }
  validates :email_non_gov, presence: true, email: true, if: -> { is_government_boolean == false }
end
