module SearchScope
  extend ActiveSupport::Concern
  included do
    scope :search_for, lambda { |fields, search_term|
      where(
        fields
        .map { |f| "data->> '#{f}' ilike '%#{search_term}%'" }
        .join(' or ')
      )
    }
  end
end
