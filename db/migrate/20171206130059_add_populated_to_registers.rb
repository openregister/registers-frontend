class AddPopulatedToRegisters < ActiveRecord::Migration[5.1]
  def change
    add_column :spina_registers, :populated, :boolean, default: false
  end
end
