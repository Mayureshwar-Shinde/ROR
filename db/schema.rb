# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_08_22_095546) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "appointments", force: :cascade do |t|
    t.date "date"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "status"
    t.integer "case_id", null: false
    t.integer "scheduler_id", null: false
    t.integer "schedulee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["case_id"], name: "index_appointments_on_case_id"
    t.index ["schedulee_id"], name: "index_appointments_on_schedulee_id"
    t.index ["scheduler_id"], name: "index_appointments_on_scheduler_id"
  end

  create_table "cases", force: :cascade do |t|
    t.string "case_number"
    t.string "title"
    t.text "description"
    t.integer "status", default: 0
    t.integer "user_id", null: false
    t.integer "assigned_to_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_to_id"], name: "index_cases_on_assigned_to_id"
    t.index ["case_number"], name: "index_cases_on_case_number", unique: true
    t.index ["user_id"], name: "index_cases_on_user_id"
  end

  create_table "notes", force: :cascade do |t|
    t.text "content", null: false
    t.integer "case_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["case_id"], name: "index_notes_on_case_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.datetime "expired_at"
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", default: "", null: false
    t.integer "age"
    t.date "date_of_birth"
    t.string "encrypted_password", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "role_type", default: 1
    t.integer "status", default: 1
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "appointments", "cases"
  add_foreign_key "appointments", "users", column: "schedulee_id"
  add_foreign_key "appointments", "users", column: "scheduler_id"
  add_foreign_key "cases", "users"
  add_foreign_key "cases", "users", column: "assigned_to_id"
  add_foreign_key "notes", "cases"
  add_foreign_key "notes", "users"
end
