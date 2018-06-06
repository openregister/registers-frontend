class AddPositionToRegisters < ActiveRecord::Migration[5.1]
  def change
    add_column :registers, :position, :integer
  end
end
