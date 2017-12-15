class AddForeignKeys < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :spina_register_id, :integer
    add_column :entries, :item_id, :integer
    add_column :records, :item_id, :integer
  end
end
