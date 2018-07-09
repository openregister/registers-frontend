# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180709102012) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "entries", force: :cascade do |t|
    t.text "hash_value"
    t.text "entry_type"
    t.text "key"
    t.datetime "timestamp"
    t.jsonb "data"
    t.bigint "register_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "entry_number"
    t.integer "previous_entry_number"
    t.index ["hash_value", "entry_type", "entry_number", "register_id", "key"], name: "unique_entry_index", unique: true
    t.index ["register_id"], name: "index_entry_on_register_id"
  end

  create_table "records", force: :cascade do |t|
    t.text "hash_value"
    t.text "entry_type"
    t.text "record_type"
    t.text "key"
    t.datetime "timestamp"
    t.jsonb "data"
    t.bigint "register_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "entry_number"
    t.index ["register_id"], name: "index_record_on_register_id"
  end

  create_table "registers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "contextual_data"
    t.string "register_phase"
    t.string "slug"
    t.string "authority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.text "related_registers"
    t.string "url"
    t.string "root_hash"
    t.text "fields_array", array: true
    t.integer "position"
    t.string "seo_title"
    t.text "meta_description"
    t.boolean "featured", default: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
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


  create_view "register_search_results", materialized: true,  sql_definition: <<-SQL
      SELECT DISTINCT registers.id AS register_id,
      registers.name,
      ((register_name_data.data -> 'register-name'::text))::character varying AS register_name,
      ((register_description_data.data -> 'text'::text))::character varying AS register_description
     FROM ((registers
       LEFT JOIN ( SELECT records.register_id,
              records.data
             FROM records
            WHERE ((records.key = 'register-name'::text) AND (records.entry_type = 'system'::text))) register_name_data ON ((register_name_data.register_id = registers.id)))
       LEFT JOIN ( SELECT records.key,
              records.data
             FROM records) register_description_data ON ((register_description_data.key = ('register:'::text || (registers.slug)::text))));
  SQL

end
