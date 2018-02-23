class SuggestRegister < ApplicationRecord
  include MultiStepModel

  validates :subject, presence: { message: 'Select a reason' }, if: :step1?
  validates :message, presence: { message: 'Enter a title' }, if: :step2?
  validates :email, presence: { message: 'Enter a valid e-mail' }, if: :step3?

  def self.total_steps
    4
  end
end
