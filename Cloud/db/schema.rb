# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170307142324) do

  create_table "accounts", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "logo_file_name",    limit: 255
    t.string   "logo_content_type", limit: 255
    t.integer  "logo_file_size",    limit: 4
    t.datetime "logo_updated_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.datetime "confirmed_at"
    t.boolean  "terms_accepted"
    t.datetime "deleted_at"
    t.string   "city",              limit: 255
    t.string   "state",             limit: 255
    t.string   "zipcode",           limit: 255
    t.string   "address",           limit: 255
    t.string   "address1",          limit: 255
  end

  add_index "accounts", ["deleted_at"], name: "index_accounts_on_deleted_at", using: :btree

  create_table "coolers", force: :cascade do |t|
    t.string   "name",                         limit: 255
    t.float    "top_temp_threshold",           limit: 24,    default: 5.0
    t.float    "bottom_temp_threshold",        limit: 24,    default: 0.0
    t.integer  "unit_id",                      limit: 4
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.text     "description",                  limit: 65535
    t.boolean  "active_notifications",                       default: true
    t.datetime "last_threshold_sent"
    t.datetime "deleted_at"
    t.float    "top_humidity_threshold",       limit: 24,    default: 99.0
    t.float    "bottom_humidity_threshold",    limit: 24,    default: 1.0
    t.boolean  "humidity_notifications",                     default: false
    t.datetime "last_humidity_threshold_sent"
  end

  add_index "coolers", ["deleted_at"], name: "index_coolers_on_deleted_at", using: :btree
  add_index "coolers", ["unit_id"], name: "index_coolers_on_unit_id", using: :btree

  create_table "hub_locations", force: :cascade do |t|
    t.string   "latitude",   limit: 255
    t.string   "longitude",  limit: 255
    t.integer  "altitude",   limit: 4
    t.float    "velocity",   limit: 24
    t.datetime "gps_time"
    t.integer  "hub_id",     limit: 4,   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "hubs", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "particle_id", limit: 255
    t.integer  "unit_id",     limit: 4,   null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "rssi",        limit: 4
    t.datetime "last_online"
    t.integer  "battery",     limit: 4
    t.datetime "deleted_at"
  end

  add_index "hubs", ["deleted_at"], name: "index_hubs_on_deleted_at", using: :btree

  create_table "line_check_items", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.float    "temp_high",          limit: 24
    t.float    "temp_low",           limit: 24
    t.integer  "order",              limit: 4
    t.text     "description",        limit: 65535
    t.datetime "deleted_at"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "line_check_list_id", limit: 4
  end

  add_index "line_check_items", ["deleted_at"], name: "index_line_check_items_on_deleted_at", using: :btree
  add_index "line_check_items", ["line_check_list_id"], name: "index_line_check_items_on_line_check_list_id", using: :btree

  create_table "line_check_lists", force: :cascade do |t|
    t.integer  "unit_id",      limit: 4
    t.string   "name",         limit: 255
    t.datetime "deleted_at"
    t.integer  "items_count",  limit: 4,   default: 0, null: false
    t.integer  "checks_count", limit: 4,   default: 0, null: false
  end

  add_index "line_check_lists", ["deleted_at"], name: "index_line_check_lists_on_deleted_at", using: :btree
  add_index "line_check_lists", ["unit_id"], name: "index_line_check_lists_on_unit_id", using: :btree

  create_table "line_check_readings", force: :cascade do |t|
    t.integer  "line_check_id",      limit: 4
    t.integer  "line_check_item_id", limit: 4
    t.float    "temp",               limit: 24
    t.boolean  "success"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.datetime "deleted_at"
  end

  add_index "line_check_readings", ["deleted_at"], name: "index_line_check_readings_on_deleted_at", using: :btree
  add_index "line_check_readings", ["line_check_id"], name: "index_line_check_readings_on_line_check_id", using: :btree
  add_index "line_check_readings", ["line_check_item_id"], name: "index_line_check_readings_on_line_check_item_id", using: :btree

  create_table "line_check_schedules", force: :cascade do |t|
    t.datetime "time",                         null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "line_check_list_id", limit: 4
    t.datetime "deleted_at"
  end

  add_index "line_check_schedules", ["deleted_at"], name: "index_line_check_schedules_on_deleted_at", using: :btree
  add_index "line_check_schedules", ["line_check_list_id"], name: "index_line_check_schedules_on_line_check_list_id", using: :btree
  add_index "line_check_schedules", ["time"], name: "index_line_check_schedules_on_time", using: :btree

  create_table "line_checks", force: :cascade do |t|
    t.integer  "created_by_id",      limit: 4
    t.integer  "completed_by_id",    limit: 4
    t.datetime "completed_at"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "line_check_list_id", limit: 4
    t.integer  "readings_count",     limit: 4, default: 0, null: false
    t.integer  "completed_count",    limit: 4, default: 0, null: false
    t.integer  "successful_count",   limit: 4, default: 0, null: false
    t.datetime "deleted_at"
  end

  add_index "line_checks", ["completed_by_id"], name: "index_line_checks_on_completed_by_id", using: :btree
  add_index "line_checks", ["created_by_id"], name: "index_line_checks_on_created_by_id", using: :btree
  add_index "line_checks", ["deleted_at"], name: "index_line_checks_on_deleted_at", using: :btree
  add_index "line_checks", ["line_check_list_id"], name: "index_line_checks_on_line_check_list_id", using: :btree

  create_table "line_items", force: :cascade do |t|
    t.integer  "order_id",   limit: 4
    t.integer  "sensor_id",  limit: 4
    t.datetime "deleted_at"
  end

  add_index "line_items", ["deleted_at"], name: "index_line_items_on_deleted_at", using: :btree
  add_index "line_items", ["order_id"], name: "index_line_items_on_order_id", using: :btree
  add_index "line_items", ["sensor_id"], name: "index_line_items_on_sensor_id", using: :btree

  create_table "notify_events", force: :cascade do |t|
    t.text     "message",       limit: 65535
    t.integer  "notify_type",   limit: 4
    t.datetime "sent_at"
    t.integer  "user_id",       limit: 4
    t.integer  "subscriber_id", limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", limit: 4,     null: false
    t.integer  "application_id",    limit: 4,     null: false
    t.string   "token",             limit: 255,   null: false
    t.integer  "expires_in",        limit: 4,     null: false
    t.text     "redirect_uri",      limit: 65535, null: false
    t.datetime "created_at",                      null: false
    t.datetime "revoked_at"
    t.string   "scopes",            limit: 255
  end

  add_index "oauth_access_grants", ["application_id"], name: "fk_rails_b4b53e07b8", using: :btree
  add_index "oauth_access_grants", ["resource_owner_id"], name: "fk_rails_330c32d8d9", using: :btree
  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id",      limit: 4
    t.integer  "application_id",         limit: 4
    t.string   "token",                  limit: 255,              null: false
    t.string   "refresh_token",          limit: 255
    t.integer  "expires_in",             limit: 4
    t.datetime "revoked_at"
    t.datetime "created_at",                                      null: false
    t.string   "scopes",                 limit: 255
    t.string   "previous_refresh_token", limit: 255, default: "", null: false
  end

  add_index "oauth_access_tokens", ["application_id"], name: "fk_rails_732cb83ab7", using: :btree
  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",         limit: 255,                null: false
    t.string   "uid",          limit: 255,                null: false
    t.string   "secret",       limit: 255,                null: false
    t.text     "redirect_uri", limit: 65535,              null: false
    t.string   "scopes",       limit: 255,   default: "", null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "unit_id",                limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "tracking_number",        limit: 255
    t.integer  "fulfilled_by_id",        limit: 4
    t.datetime "fulfillment_started_at"
    t.datetime "fulfilled_at"
    t.datetime "deleted_at"
  end

  add_index "orders", ["deleted_at"], name: "index_orders_on_deleted_at", using: :btree
  add_index "orders", ["fulfilled_by_id"], name: "index_orders_on_fulfilled_by_id", using: :btree
  add_index "orders", ["fulfillment_started_at"], name: "index_orders_on_fulfillment_started_at", using: :btree
  add_index "orders", ["unit_id"], name: "index_orders_on_unit_id", using: :btree

  create_table "permissions", force: :cascade do |t|
    t.integer "account_user_id", limit: 4
    t.integer "unit_id",         limit: 4
  end

  add_index "permissions", ["account_user_id"], name: "index_permissions_on_account_user_id", using: :btree
  add_index "permissions", ["unit_id"], name: "index_permissions_on_unit_id", using: :btree

  create_table "sensor_readings", force: :cascade do |t|
    t.boolean  "success"
    t.datetime "reading_time",                            null: false
    t.float    "temp",         limit: 24
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "battery",      limit: 4
    t.decimal  "humidity",                 precision: 10
    t.string   "parent_mac",   limit: 255
    t.integer  "rssi",         limit: 4
    t.integer  "sensor_id",    limit: 4
  end

  create_table "sensors", force: :cascade do |t|
    t.string   "mac",                       limit: 255
    t.integer  "location_id",               limit: 4
    t.integer  "unit_id",                   limit: 4
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.datetime "last_online"
    t.string   "name",                      limit: 255
    t.string   "location_type",             limit: 255
    t.string   "parent_mac",                limit: 255
    t.integer  "battery",                   limit: 4
    t.integer  "readings_count",            limit: 4,   default: 0, null: false
    t.integer  "successful_readings_count", limit: 4,   default: 0, null: false
    t.integer  "rssi",                      limit: 4
    t.float    "temp",                      limit: 24
    t.float    "humidity",                  limit: 24
    t.datetime "deleted_at"
  end

  add_index "sensors", ["deleted_at"], name: "index_sensors_on_deleted_at", using: :btree
  add_index "sensors", ["location_id", "location_type"], name: "index_sensors_on_location_id_and_location_type", unique: true, using: :btree
  add_index "sensors", ["mac"], name: "index_sensors_on_mac", unique: true, using: :btree

  create_table "units", force: :cascade do |t|
    t.string   "name",                               limit: 255
    t.string   "city",                               limit: 255
    t.string   "state",                              limit: 255
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.string   "logo_file_name",                     limit: 255
    t.string   "logo_content_type",                  limit: 255
    t.integer  "logo_file_size",                     limit: 4
    t.datetime "logo_updated_at"
    t.string   "address",                            limit: 255
    t.string   "address1",                           limit: 255
    t.string   "zipcode",                            limit: 255
    t.integer  "recurring_notify_duration",          limit: 4,   default: 60
    t.float    "notify_threshold",                   limit: 24,  default: 5.0
    t.integer  "users_count",                        limit: 4,   default: 0,   null: false
    t.boolean  "probe_enabled"
    t.integer  "temps_count",                        limit: 4,   default: 0,   null: false
    t.integer  "compliant_temps_count",              limit: 4,   default: 0,   null: false
    t.integer  "account_id",                         limit: 4
    t.datetime "deleted_at"
    t.integer  "humidity_recurring_notify_duration", limit: 4,   default: 60
    t.float    "humidity_notify_threshold",          limit: 24,  default: 1.0
  end

  add_index "units", ["account_id"], name: "index_units_on_account_id", using: :btree
  add_index "units", ["deleted_at"], name: "index_units_on_deleted_at", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "firstname",              limit: 255
    t.string   "lastname",               limit: 255
    t.string   "time_zone",              limit: 255, default: "Eastern Time (US & Canada)"
    t.string   "email",                  limit: 255, default: "",                           null: false
    t.string   "encrypted_password",     limit: 255, default: "",                           null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,                            null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",        limit: 4,   default: 0,                            null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.integer  "unit_id",                limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name",       limit: 255
    t.string   "avatar_content_type",    limit: 255
    t.integer  "avatar_file_size",       limit: 4
    t.datetime "avatar_updated_at"
    t.string   "authentication_token",   limit: 255
    t.integer  "default_units",          limit: 4,   default: 1
    t.boolean  "email_notification",                 default: true
    t.boolean  "daily_notification",                 default: true
    t.string   "phone",                  limit: 255
    t.boolean  "sms_notification",                   default: false
    t.integer  "report_frequency",       limit: 4,   default: 0
    t.integer  "report_time",            limit: 4,   default: 6
    t.integer  "report_weekday",         limit: 4,   default: 0
    t.integer  "report_day",             limit: 4,   default: 1
    t.datetime "last_report_sent_at"
    t.boolean  "support_access",                     default: false
    t.datetime "device_last_online"
    t.integer  "report_type",            limit: 4,   default: 0
    t.string   "email_token",            limit: 255
    t.boolean  "probe_enabled"
    t.string   "type",                   limit: 255
    t.integer  "account_id",             limit: 4
    t.boolean  "account_admin"
  end

  add_index "users", ["account_id"], name: "index_users_on_account_id", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["id", "type"], name: "index_users_on_id_and_type", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  add_foreign_key "line_items", "orders"
  add_foreign_key "line_items", "sensors"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_grants", "users", column: "resource_owner_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id"
  add_foreign_key "orders", "units"
  add_foreign_key "permissions", "units"
  add_foreign_key "permissions", "users", column: "account_user_id"
  add_foreign_key "units", "accounts"
  add_foreign_key "users", "accounts"
end
