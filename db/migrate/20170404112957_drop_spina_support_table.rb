class DropSpinaSupportTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :spina_supports
  end
end
