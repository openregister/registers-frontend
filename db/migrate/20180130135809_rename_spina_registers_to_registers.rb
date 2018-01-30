class RenameSpinaRegistersToRegisters < ActiveRecord::Migration[5.1]
  def change
    rename_table :spina_registers, :registers
    rename_column :entries, :spina_register_id, :register_id
    rename_column :records, :spina_register_id, :register_id
    rename_index :entries, 'index_entry_on_spina_register_id', 'index_entry_on_register_id'
    rename_index :records, 'index_record_on_spina_register_id', 'index_record_on_register_id'
  end
end
