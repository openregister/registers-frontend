class AddFieldsToRegisters < ActiveRecord::Migration[5.1]
  def change
    add_column :spina_registers, :fields, :text
  end
end
