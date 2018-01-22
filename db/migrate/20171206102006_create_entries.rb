class CreateEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :entries do |t|
      t.text :hash_value
      t.text :entry_type
      t.text :key
      t.datetime :timestamp
      t.jsonb :data
      t.bigint :spina_register_id
      t.index :spina_register_id, name: :index_entry_on_spina_register_id

      t.timestamps
    end
  end
end
