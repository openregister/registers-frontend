class RenameOwnerToAuthorities < ActiveRecord::Migration[5.0]
  def change
    rename_column :spina_registers, :owner, :authority
  end
end
