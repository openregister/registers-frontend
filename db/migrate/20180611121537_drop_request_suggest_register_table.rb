class DropRequestSuggestRegisterTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :suggest_registers
    drop_table :request_registers
  end
end
