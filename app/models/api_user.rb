class ApiUser
  include ActiveModel::Model
  include ActiveModel::Translation
  include FormConcerns
  attr_accessor :email_gov, :email_non_gov, :is_government, :contactable

  validates :contactable, presence: true, if: -> { is_government_boolean == true }

  def is_contactable_boolean
    case contactable
    when 'yes'
      true
    when 'no'
      false
    end
  end
end
