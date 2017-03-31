class CreateSpinaSupports < ActiveRecord::Migration[5.0]
  def change
    create_table :spina_supports do |t|
      t.string :register_name
      t.string :name
      t.string :email
      t.string :message
      t.string :subject
    end
  end
end
