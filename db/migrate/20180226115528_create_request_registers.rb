class CreateRequestRegisters < ActiveRecord::Migration[5.1]
  def change
    create_table :request_registers do |t|
      t.string :email
      t.string :subject
      t.string :message

      t.timestamps
    end
  end
end
