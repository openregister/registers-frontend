class AddUniqueConstraintToEntries < ActiveRecord::Migration[5.1]
  def change
    add_index(:entries, %i[hash_value entry_type entry_number spina_register_id], unique: true, name: 'unique_entry_index')
  end
end
