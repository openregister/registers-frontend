class RemoveCustodianFromSpinaRegisters < ActiveRecord::Migration[5.1]
  def change
    remove_column :spina_registers, :custodian
    remove_column :spina_registers, :url
  end
end
