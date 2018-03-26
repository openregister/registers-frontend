class ApiUser
  include ActiveModel::Model

  attr_accessor :email, :service, :department, :api_key

  #before_save :set_api_key

  validates :email, presence: true

private

  def set_api_key
    if self.api_key.blank?
      self.api_key = SecureRandom.uuid
    end
  end
end
