class DownloadUser
  include ActiveModel::Model
  include ActiveModel::Translation
  include FormValidations
  attr_accessor :email_gov, :email_non_gov, :non_gov_use_category, :department, :is_government, :register
end
