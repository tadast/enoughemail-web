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

ActiveRecord::Schema[7.0].define(version: 2023_01_06_142228) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

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

  create_table "email_addresses", force: :cascade do |t|
    t.bigint "gmail_user_id", null: false
    t.text "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gmail_user_id"], name: "index_email_addresses_on_gmail_user_id"
  end

  create_table "filter_lists", force: :cascade do |t|
    t.text "name"
    t.text "description"
    t.text "email_pattern"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "filter_rules", force: :cascade do |t|
    t.text "email_pattern", null: false
    t.bigint "user_id", null: false
    t.bigint "organization_id", null: false
    t.string "source"
    t.string "scope"
    t.boolean "applied", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "filter_list_id"
    t.index ["filter_list_id"], name: "index_filter_rules_on_filter_list_id"
    t.index ["organization_id"], name: "index_filter_rules_on_organization_id"
    t.index ["user_id"], name: "index_filter_rules_on_user_id"
  end

  create_table "gmail_user_filter_rules", force: :cascade do |t|
    t.bigint "gmail_user_id", null: false
    t.bigint "filter_rule_id", null: false
    t.text "google_filter_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["filter_rule_id"], name: "index_gmail_user_filter_rules_on_filter_rule_id"
    t.index ["gmail_user_id", "filter_rule_id", "google_filter_id"], name: "index_gmail_user_filer_rule_uniqueness", unique: true
    t.index ["gmail_user_id"], name: "index_gmail_user_filter_rules_on_gmail_user_id"
  end

  create_table "gmail_users", force: :cascade do |t|
    t.string "email"
    t.bigint "organization_id", null: false
    t.bigint "user_id"
    t.string "gid"
    t.text "full_name"
    t.boolean "archived", default: false, null: false
    t.datetime "google_created_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_gmail_users_on_organization_id"
    t.index ["user_id"], name: "index_gmail_users_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.text "domain"
    t.string "billing_email"
    t.text "google_domain_wide_delegation_credentials"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "admin_email"
    t.text "slack_webhook_url"
    t.text "google_auth_scope_set", default: "with_labels"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.bigint "organization_id"
    t.string "role", default: "imported"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "email_addresses", "gmail_users"
  add_foreign_key "filter_rules", "filter_lists"
  add_foreign_key "filter_rules", "organizations"
  add_foreign_key "filter_rules", "users"
  add_foreign_key "gmail_user_filter_rules", "filter_rules"
  add_foreign_key "gmail_user_filter_rules", "gmail_users"
  add_foreign_key "gmail_users", "organizations"
  add_foreign_key "gmail_users", "users"
  add_foreign_key "users", "organizations"
end
