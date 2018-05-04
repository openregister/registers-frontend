class ApiUser
  include ActiveModel::Model
  attr_accessor :email, :service, :department, :is_government
  validates_presence_of :is_government
end
