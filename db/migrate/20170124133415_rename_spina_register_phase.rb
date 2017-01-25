class RenameSpinaRegisterPhase < ActiveRecord::Migration[5.0]
  def change
    rename_column :spina_registers, :phase, :register_phase
  end
end
