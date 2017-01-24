class AddPositionToSteps < ActiveRecord::Migration[5.0]
  def change
    add_column :spina_steps, :position, :integer, default: 0, null: false
  end
end
