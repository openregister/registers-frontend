class CreateSpinaRegisters < ActiveRecord::Migration[5.0]
  def change
    create_table :spina_registers do |t|
      t.string :name
      t.string :url
      t.text :history
      t.string :phase
      t.string :slug
      t.string :custodian
      t.string :owner
      t.timestamps
    end
  end
end
