require 'active_support/concern'

module FormConcerns
  extend ActiveSupport::Concern
  included do
    validates :is_government, presence: true

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
