class AddRootHashToRegister < ActiveRecord::Migration[5.1]
  def change
    add_column :registers, :root_hash, :string
  end
end
