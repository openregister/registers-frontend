class GovernmentOrganisation < ApplicationRecord

  self.primary_key = 'key'
  has_many :registers
  
  def self.refresh
    Scenic.database.refresh_materialized_view(table_name, concurrently: false, cascade: false)
  end
end
