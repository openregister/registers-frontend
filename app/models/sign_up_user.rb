class SignUpUser
  include ActiveModel::Model
  include ActiveModel::Translation
  include FormConcerns
  attr_accessor :email

  validates :email, presence: true, email: true
end
  