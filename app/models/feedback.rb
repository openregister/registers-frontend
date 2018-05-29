class Feedback
  include ActiveModel::Model
  include ActiveModel::Translation

  attr_accessor :email, :message, :useful, :reason, :subject

  validates :useful, presence: true
  validates :reason, presence: true, if: -> { useful == "no" }
end
