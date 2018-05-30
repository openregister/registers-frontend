require 'active_support/concern'

module FormConcerns
  extend ActiveSupport::Concern
  included do
    validates :is_government, inclusion: { in: [true, false] }
    validates :email_non_gov, presence: true, email: true, unless: -> { is_government }
    validates :email_gov, presence: true, email: true, if: -> { is_government }

    def email
      is_government ? email_gov : email_non_gov
    end
  end
end
