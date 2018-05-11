class ApiUser
  include ActiveModel::Model
  attr_accessor :email_gov, :email_non_gov, :non_gov_use_category, :department, :is_government

  validates :is_government, presence: true
  validates :email_gov, presence: true, if: -> { is_government == 'yes' }
  validates :department, presence: true, if: -> { is_government == 'yes' }
  validates :email_non_gov, presence: true, if: -> { is_government == 'no' }
  validates :non_gov_use_category, presence: true, if: -> { is_government == 'no' }
end
