class CreateAuthorities < ActiveRecord::Migration[5.2]
  def change
    create_table :authorities do |t|
      t.string :government_organisation_key, null: false
      t.string :registers_description
      t.string :name
      t.index :government_organisation_key, unique: true
      t.timestamps
    end

    add_column :registers, :authority_id, :bigint
    add_foreign_key :registers, :authorities
  end
end
