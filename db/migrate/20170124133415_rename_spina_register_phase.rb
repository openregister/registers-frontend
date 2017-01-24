class RenameSpinaRegisterPhase < ActiveRecord::Migration[5.0]
  def change
    rename_column :spina_registers, :phase, :current_phase
  end
end
