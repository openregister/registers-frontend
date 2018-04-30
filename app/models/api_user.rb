class ApiUser
  include ActiveModel::Model
  attr_accessor :email, :service, :department, :is_government
end
