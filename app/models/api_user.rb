class ApiUser
  include ActiveModel::Model
  include ActiveModel::Translation
  include FormConcerns
  attr_accessor :email_gov, :email_non_gov, :is_government
end
