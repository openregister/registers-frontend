class ChangeThemeToCategory < ActiveRecord::Migration[5.2]
  def change
    rename_table :themes, :categories
    rename_column :registers, :theme_id, :category_id
  end
end
