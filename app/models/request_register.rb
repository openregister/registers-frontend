class RequestRegister < ApplicationRecord
  include MultiStepModel

  validates :subject, presence: { message: 'Select a reason' }, if: :step1?
  validates :email, presence: { message: 'Enter a valid e-mail' }, if: :step3?

  def self.total_steps
    2
  end
end
