require 'active_support/concern'

module FormConcerns
  extend ActiveSupport::Concern
  included do
    validates :is_government, inclusion: { in: [true, false] }
    validates :department, presence: true, if: -> { is_government }
    validates :department, absence: true, unless: -> { is_government }
    validates :non_gov_use_category, presence: true, if: -> { is_government == false }
    validates :non_gov_use_category, absence: true, if: -> { is_government }
    validates :email_non_gov, presence: true, email: true, unless: -> { is_government.nil? || is_government == true }
    validates :email_gov, presence: true, email: true, unless: -> { is_government.nil? || is_government == false }

    def email
      is_government ? email_gov : email_non_gov
    end
  end
end
