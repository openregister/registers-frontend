class CreateEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :entries do |t|
      t.text :hash_value
      t.text :entry_type
      t.text :key
      t.datetime :timestamp
      t.jsonb :data

      t.timestamps
    end
  end
end
