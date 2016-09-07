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

ActiveRecord::Schema.define(version: 20160907084526) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "oiltypes", force: :cascade do |t|
    t.string  "name"
    t.integer "code"
    t.integer "standard_id"
    t.index ["standard_id"], name: "index_oiltypes_on_standard_id", using: :btree
  end

  create_table "records", force: :cascade do |t|
    t.integer  "region_id"
    t.decimal  "value",       precision: 5, scale: 2
    t.integer  "user_id"
    t.integer  "revision_id"
    t.integer  "oiltype_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "uploaded"
    t.index ["oiltype_id"], name: "index_records_on_oiltype_id", using: :btree
    t.index ["region_id"], name: "index_records_on_region_id", using: :btree
    t.index ["revision_id"], name: "index_records_on_revision_id", using: :btree
    t.index ["user_id"], name: "index_records_on_user_id", using: :btree
  end

  create_table "regions", force: :cascade do |t|
    t.integer "code"
    t.text    "name"
  end

  create_table "revisions", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_revisions_on_user_id", using: :btree
  end

  create_table "standards", force: :cascade do |t|
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["name"], name: "index_users_on_name", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "oiltypes", "standards"
  add_foreign_key "records", "oiltypes"
  add_foreign_key "records", "regions"
  add_foreign_key "records", "revisions"
  add_foreign_key "records", "users"
  add_foreign_key "revisions", "users"
end
