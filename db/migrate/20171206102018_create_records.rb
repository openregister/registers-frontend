class CreateRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :records do |t|
      t.text :hash_value
      t.text :record_type
      t.text :key
      t.datetime :timestamp
      t.jsonb :data

      t.timestamps
    end
  end
end
