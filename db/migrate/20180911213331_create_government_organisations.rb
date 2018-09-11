class CreateGovernmentOrganisations < ActiveRecord::Migration[5.2]
  def change
    create_view :government_organisations, materialized: true
  end
end
