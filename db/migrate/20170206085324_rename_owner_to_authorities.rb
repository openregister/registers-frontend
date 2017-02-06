class RenameauthorityToAuthorities < ActiveRecord::Migration[5.0]
  def change
    rename_column :spina_registers, :authority, :authority
  end
end
