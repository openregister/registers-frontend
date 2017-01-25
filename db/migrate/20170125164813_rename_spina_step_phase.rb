class RenameSpinaStepPhase < ActiveRecord::Migration[5.0]
  def change
    rename_column :spina_steps, :phase, :step_phase
  end
end
