class CreateDownloadTable < ActiveRecord::Migration[5.1]
  def change
    create_table :download_users do |t|
      t.string :is_government
      t.string :department
      t.string :email
      t.string :non_gov_use_category
      t.timestamps
    end
  end
end
