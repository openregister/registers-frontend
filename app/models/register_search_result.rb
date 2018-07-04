class RegisterSearchResult < ActiveRecord::Base
  self.primary_key = 'register_id'
  scope :search, ->(search_term) { where(*['name ILIKE ? OR register_name ILIKE ? OR register_description ILIKE ?'].fill("%#{sanitize_sql_like(search_term)}%", 1..3)) }

  def readonly?
    true
  end

  def self.search_for(search_term)
    Register.where(id: search(search_term).ids)
  end
end
