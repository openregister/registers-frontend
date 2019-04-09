class RemoveUsersTable < ActiveRecord::Migration[5.2]
  def change
    drop_table "users", id: :serial, force: :cascade do |t|
      t.string "name"
      t.string "email"
      t.string "password_digest"
      t.boolean "admin", default: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.datetime "last_logged_in"
      t.string "password_reset_token"
      t.datetime "password_reset_sent_at"
    end
  end
end
