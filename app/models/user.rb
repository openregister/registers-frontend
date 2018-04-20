class User < ApplicationRecord
  has_secure_password
  has_secure_token :password_reset_token

  validates_presence_of :name, :email
  validates_presence_of :password, on: :create
  validate :uniqueness_of_email
  validates :email, format: { with: /\A[^@]+@[^@]+\z/ }

  def admin?
    admin
  end

  def to_s
    name
  end

private

  def uniqueness_of_email
    if email_changed? && User.where(email: email).exists?
      errors.add(:email, 'Sorry, a user with this email address already exists')
    end
  end
end
