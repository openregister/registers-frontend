class ApiUser
  include ActiveModel::Model
  include FormValidations
  attr_accessor :email_gov, :email_non_gov, :non_gov_use_category, :department, :is_government
end
