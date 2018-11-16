class AddTitleToRegister < ActiveRecord::Migration[5.2]
  def change
    add_column :registers, :title, :string
  end
end
