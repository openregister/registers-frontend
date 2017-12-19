class RenameHistoryToContextualDataInSpinaRegisters < ActiveRecord::Migration[5.1]
  def change
    rename_column :spina_registers, :history, :contextual_data
  end
end
