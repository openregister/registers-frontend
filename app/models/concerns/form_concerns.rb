require 'active_support/concern'

module FormConcerns
  extend ActiveSupport::Concern
  included do
    validates :is_government, presence: true
    validates :email_gov, presence: true, email: true, if: -> { is_government_boolean == true }
    validates :email_non_gov, allow_blank: true, email: true, if: -> { is_government_boolean == false }
    validates :contactable, presence: true, if: -> { is_government_boolean == true }

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

    def is_contactable_boolean
      case contactable
      when 'yes'
        true
      when 'no'
        false
      end
    end
  end
end
