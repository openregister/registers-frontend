class RemoveRootHashFromRegisters < ActiveRecord::Migration[5.2]
  def change
    remove_column :registers, :root_hash, :string
  end
end
