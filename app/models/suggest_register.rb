class SuggestRegister < ApplicationRecord
  include MultiStepModel

  validates :reason, presence: true, if: :step1?
  validates :title, presence: true, if: :step2?
  validates :email, presence: true, if: :step3?

  def self.total_steps
    4
  end
end
