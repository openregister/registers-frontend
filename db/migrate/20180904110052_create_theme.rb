class CreateTheme < ActiveRecord::Migration[5.2]
  def change
    create_table :themes do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :description
      t.uuid :taxon_content_id
      t.index :slug, unique: true
    end
  end
end
