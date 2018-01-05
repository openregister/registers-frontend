class DropSpinaStep < ActiveRecord::Migration[5.1]
  def change
    drop_table :spina_steps
  end
end
