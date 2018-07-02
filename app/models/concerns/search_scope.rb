module SearchScope
  extend ActiveSupport::Concern
  included do
    scope :search_for, lambda { |fields, search_term|
      if search_term.present?
        search_arguments = [].fill("%#{sanitize_sql_like(search_term)}%", 1..fields.length).compact
        where(*
          [fields
          .map { |f| "data->> '#{f}' ilike ?" }
          .join(' or ')].concat(search_arguments))
      end
    }
  end
end
