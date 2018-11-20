class RegisterSearchResult < ApplicationRecord
  self.primary_key = 'register_id'
  scope :search, ->(search_term) { where(*['register_search_results.name ILIKE ? OR title ILIKE ? OR register_description ILIKE ?'].fill("%#{sanitize_sql_like(search_term)}%", 1..3)) }
  belongs_to :register

  def readonly?
    true
  end

  def self.refresh
    Scenic.database.refresh_materialized_view(table_name, concurrently: false, cascade: false)
  end
end
