class AddUrlToRegisters < ActiveRecord::Migration[5.1]
  def change
    add_column :registers, :url, :string
  end
end
