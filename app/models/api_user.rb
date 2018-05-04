class ApiUser
  include ActiveModel::Model
  attr_accessor :email_gov, :email_non_gov, :service, :department, :is_government
  validates_presence_of :is_government
end
