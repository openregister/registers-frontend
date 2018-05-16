require 'active_support/concern'

module FormValidations extend ActiveSupport::Concern
                       included do
                         validates :is_government, inclusion: { in: [true, false] }
                         validates :email_gov, presence: true, if: -> { is_government == true }
                         validates :department, presence: true, if: -> { is_government == true  }
                         validates :department, absence: true, if: -> { is_government == false  }
                         validates :email_non_gov, presence: true, if: -> { is_government == false }
                         validates :non_gov_use_category, presence: true, if: -> { is_government == false }
                         validates :non_gov_use_category, absence: true, if: -> { is_government == true }
                       end
end
