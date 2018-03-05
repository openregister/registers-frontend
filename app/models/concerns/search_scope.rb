module SearchScope
  extend ActiveSupport::Concern
  included do
    scope :search_for, lambda { |fields, search_term|
      if search_term.present?
        where(
          fields
          .map { |f| "data->> '#{f}' ilike '%#{search_term}%'" }
          .join(' or ')
          )
      end
    }
  end
end
