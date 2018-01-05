class ChangeSpinaRegisterDescriptionToString < ActiveRecord::Migration[5.1]
  def self.up
    change_column :spina_registers, :description, :string
  end

  def self.down
    change_column :spina_registers, :description, :text
  end
end
