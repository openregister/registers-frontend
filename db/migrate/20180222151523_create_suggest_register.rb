class CreateSuggestRegister < ActiveRecord::Migration[5.1]
  def change
    create_table :suggest_registers do |t|
      t.string :email
      t.string :message
      t.string :subject
    end
  end
end
