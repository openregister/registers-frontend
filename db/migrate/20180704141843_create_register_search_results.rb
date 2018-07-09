class CreateRegisterSearchResults < ActiveRecord::Migration[5.1]
  def change
    create_view :register_search_results, materialized: true
  end
end
