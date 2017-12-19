class AddRelatedRegistersToSpinaRegisters < ActiveRecord::Migration[5.1]
  def change
    add_column :spina_registers, :related_registers, :text
  end
end
