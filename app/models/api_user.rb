class ApiUser
  include ActiveModel::Model
  attr_accessor :email, :service, :department, :is_government
  validates_presence_of :email, :is_government
end
