class AddThemeIdToRegister < ActiveRecord::Migration[5.2]
  def change
    add_column :registers, :theme_id, :bigint
    add_foreign_key :registers, :themes
  end
end
