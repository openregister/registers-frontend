require 'active_support/concern'

module FormConcerns
  extend ActiveSupport::Concern
  included do
    validates :is_government, inclusion: { in: %w[yes no] }
    validates :email_gov, presence: true, email: true, if: -> { is_government_boolean == true }
    validates :email_non_gov, allow_blank: true, email: true, if: -> { is_government_boolean == false }

    def email
      is_government_boolean ? email_gov : email_non_gov
    end

    def is_government_boolean
      case is_government
      when 'yes'
        true
      when 'no'
        false
      end
    end
  end
end
