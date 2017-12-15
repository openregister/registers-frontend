class DropSpinaPhase < ActiveRecord::Migration[5.1]
  def change
    drop_table :spina_phases
  end
end
