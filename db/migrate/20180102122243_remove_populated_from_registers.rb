class RemovePopulatedFromRegisters < ActiveRecord::Migration[5.1]
  def change
    remove_column :spina_registers, :populated
  end
end
