class CreateEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :entries do |t|
      t.text :hash_value
      t.integer :entry_number
      t.integer :previous_entry_number
      t.text :entry_type
      t.text :key
      t.datetime :timestamp
      t.jsonb :data

      t.timestamps
    end
  end
end
