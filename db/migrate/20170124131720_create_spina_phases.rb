class CreateSpinaPhases < ActiveRecord::Migration[5.0]
  def change
    create_table :spina_phases do |t|
      t.string :name
      t.string :phase_update
      t.integer :position
      t.integer :register_id

      t.timestamps
    end
  end
end
