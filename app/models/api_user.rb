class ApiUser
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  attr_accessor :email, :service, :department, :api_key

  validates :email, presence: true

  after_validation :set_api_key

private

  def set_api_key
    return unless errors.blank?
    if self.api_key.blank?
      self.api_key = SecureRandom.uuid
    end
  end
end
