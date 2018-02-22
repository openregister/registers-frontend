class CreateSuggestRegister < ActiveRecord::Migration[5.1]
  def change
    create_table :suggest_registers do |t|
      t.string :email
      t.string :title
      t.string :reason
    end
  end
end
