class CreateRegisterSearchResults < ActiveRecord::Migration[5.1]
  def change
    create_view :register_search_results
  end
end
