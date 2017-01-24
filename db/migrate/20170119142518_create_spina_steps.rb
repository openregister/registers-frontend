class CreateSpinaSteps < ActiveRecord::Migration[5.0]
  def change
    create_table :spina_steps do |t|
      t.string :title
      t.string :phase
      t.text :content
      t.boolean :completed, default: false
      t.integer :register_id
      t.timestamps
    end

    add_index :spina_steps, :register_id
  end
end
