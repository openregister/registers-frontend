class RemoveFieldsCommaSeparated < ActiveRecord::Migration[5.1]
  def change
    remove_column :registers, :fields
  end
end
