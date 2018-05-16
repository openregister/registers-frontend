class IsGovernmentBoolean < ActiveRecord::Migration[5.1]
  def change
    remove_column :download_users, :is_government
    add_column :download_users, :is_government, :boolean
  end
end
