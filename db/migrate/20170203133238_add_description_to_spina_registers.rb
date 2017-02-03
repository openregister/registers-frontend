class AddDescriptionToSpinaRegisters < ActiveRecord::Migration[5.0]
  def change
    add_column :spina_registers, :description, :text
  end
end
