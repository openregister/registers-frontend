class AddFeaturedToRegisters < ActiveRecord::Migration[5.1]
  def change
    add_column :registers, :featured, :boolean, default: false
  end
end
