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

ActiveRecord::Schema.define(version: 20150805112914) do

  create_table "act_records", force: :cascade do |t|
    t.integer  "activity_id", limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "act_records", ["activity_id"], name: "index_act_records_on_activity_id", using: :btree

  create_table "activities", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "item_type",       limit: 255
    t.integer  "discount_manner", limit: 4
    t.integer  "amount",          limit: 4
    t.text     "content",         limit: 65535
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "addup",           limit: 1
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "consume_add_up",  limit: 4,     default: 1
    t.integer  "atype",           limit: 4,     default: 0
    t.integer  "original_price",  limit: 4,     default: 0
    t.integer  "real_income",     limit: 4,     default: 0
  end

  create_table "activity_codes", force: :cascade do |t|
    t.integer  "activity_id", limit: 4
    t.string   "code",        limit: 255
    t.integer  "customer_id", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "order_id",    limit: 4
  end

  add_index "activity_codes", ["activity_id"], name: "index_activity_codes_on_activity_id", using: :btree
  add_index "activity_codes", ["customer_id"], name: "index_activity_codes_on_customer_id", using: :btree
  add_index "activity_codes", ["order_id"], name: "index_activity_codes_on_order_id", using: :btree

  create_table "addresses", force: :cascade do |t|
    t.integer  "addressable_id",   limit: 4
    t.string   "addressable_type", limit: 255
    t.string   "country",          limit: 255, default: ""
    t.string   "province",         limit: 255, default: ""
    t.string   "city",             limit: 255, default: ""
    t.string   "district",         limit: 255, default: ""
    t.string   "details",          limit: 255, default: ""
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "zip_code",         limit: 4,   default: 0
    t.datetime "deleted_at"
    t.integer  "atype",            limit: 4
    t.string   "name",             limit: 255
    t.string   "phone",            limit: 255
  end

  add_index "addresses", ["addressable_id", "addressable_type"], name: "index_addresses_on_addressable_id_and_addressable_type", using: :btree
  add_index "addresses", ["atype"], name: "index_addresses_on_atype", using: :btree
  add_index "addresses", ["deleted_at"], name: "index_addresses_on_deleted_at", using: :btree

  create_table "appointments", force: :cascade do |t|
    t.integer  "customer_id",       limit: 4
    t.date     "date"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.boolean  "trouble",           limit: 1,     default: false
    t.string   "trouble_desc",      limit: 255
    t.integer  "trouble_type",      limit: 4
    t.integer  "atype",             limit: 4
    t.boolean  "finished",          limit: 1,     default: false
    t.string   "name",              limit: 255
    t.string   "phone",             limit: 255
    t.boolean  "cancel",            limit: 1,     default: false
    t.text     "cancel_reason",     limit: 65535
    t.integer  "cancel_type",       limit: 4
    t.string   "date_detail_start", limit: 255
    t.string   "date_detail_end",   limit: 255
    t.string   "weixin",            limit: 255
    t.integer  "fetcher_id",        limit: 4
    t.integer  "deliverer_id",      limit: 4
  end

  add_index "appointments", ["customer_id"], name: "index_appointments_on_customer_id", using: :btree
  add_index "appointments", ["deliverer_id"], name: "index_appointments_on_deliverer_id", using: :btree
  add_index "appointments", ["fetcher_id"], name: "index_appointments_on_fetcher_id", using: :btree
  add_index "appointments", ["phone"], name: "index_appointments_on_phone", using: :btree

  create_table "badnesses", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "deleted_at", limit: 4
  end

  add_index "badnesses", ["deleted_at"], name: "index_badnesses_on_deleted_at", using: :btree

  create_table "barcodes", force: :cascade do |t|
    t.string   "number",               limit: 255
    t.string   "barcode_file_name",    limit: 255
    t.string   "barcode_content_type", limit: 255
    t.integer  "barcode_file_size",    limit: 4
    t.datetime "barcode_updated_at"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "barcodes", ["number"], name: "index_barcodes_on_number", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.integer  "parent_id",      limit: 4
    t.integer  "lft",            limit: 4,               null: false
    t.integer  "rgt",            limit: 4,               null: false
    t.integer  "depth",          limit: 4,   default: 0, null: false
    t.integer  "children_count", limit: 4,   default: 0, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.datetime "deleted_at"
  end

  add_index "categories", ["deleted_at"], name: "index_categories_on_deleted_at", using: :btree
  add_index "categories", ["lft"], name: "index_categories_on_lft", using: :btree
  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree
  add_index "categories", ["rgt"], name: "index_categories_on_rgt", using: :btree

  create_table "cities", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "province_id", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "cities", ["province_id"], name: "index_cities_on_province_id", using: :btree

  create_table "colors", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "value",      limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "colors", ["value"], name: "index_colors_on_value", using: :btree

  create_table "compensates", force: :cascade do |t|
    t.integer  "ctype",       limit: 4
    t.integer  "amount",      limit: 4
    t.text     "reason",      limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "order_id",    limit: 4
    t.integer  "customer_id", limit: 4
    t.integer  "pm",          limit: 4
  end

  add_index "compensates", ["customer_id"], name: "index_compensates_on_customer_id", using: :btree
  add_index "compensates", ["order_id"], name: "index_compensates_on_order_id", using: :btree

  create_table "consumption_records", force: :cascade do |t|
    t.integer  "customer_id",    limit: 4
    t.integer  "payment_method", limit: 4
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.text     "remark",         limit: 65535
    t.integer  "raw_amount",     limit: 4,     default: 0
    t.string   "member_phone",   limit: 255
    t.string   "member_name",    limit: 255
    t.boolean  "recharge",       limit: 1,     default: false
  end

  add_index "consumption_records", ["customer_id"], name: "index_consumption_records_on_customer_id", using: :btree

  create_table "consumption_records_orders", id: false, force: :cascade do |t|
    t.integer "consumption_record_id", limit: 4
    t.integer "order_id",              limit: 4
  end

  add_index "consumption_records_orders", ["consumption_record_id"], name: "index_consumption_records_orders_on_consumption_record_id", using: :btree
  add_index "consumption_records_orders", ["order_id"], name: "index_consumption_records_orders_on_order_id", using: :btree

  create_table "customer_activities", force: :cascade do |t|
    t.integer  "customer_id", limit: 4
    t.integer  "activity_id", limit: 4
    t.integer  "order_count", limit: 4, default: 0
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "customer_activities", ["activity_id"], name: "index_customer_activities_on_activity_id", using: :btree
  add_index "customer_activities", ["customer_id", "activity_id"], name: "index_customer_activities_on_customer_id_and_activity_id", using: :btree

  create_table "desc_tags", force: :cascade do |t|
    t.string   "names",         limit: 255
    t.string   "category_ids",  limit: 255
    t.integer  "photo_desc_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "desc_tags", ["photo_desc_id"], name: "index_desc_tags_on_photo_desc_id", using: :btree

  create_table "districts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "city_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "districts", ["city_id"], name: "index_districts_on_city_id", using: :btree

  create_table "expresses", force: :cascade do |t|
    t.integer  "expressable_id",   limit: 4
    t.string   "expressable_type", limit: 255
    t.integer  "company_type",     limit: 4
    t.string   "number",           limit: 255
    t.integer  "price",            limit: 4
    t.boolean  "cash_on_delivery", limit: 1
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "expresses", ["expressable_id"], name: "index_expresses_on_expressable_id", using: :btree

  create_table "flaws", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "deleted_at", limit: 4
  end

  add_index "flaws", ["deleted_at"], name: "index_flaws_on_deleted_at", using: :btree

  create_table "friends", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "phone",           limit: 255
    t.string   "weixin",          limit: 255
    t.integer  "customer_id",     limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "ftype",           limit: 4
    t.string   "weixin_nickname", limit: 255
    t.integer  "order_id",        limit: 4
  end

  add_index "friends", ["customer_id"], name: "index_friends_on_customer_id", using: :btree
  add_index "friends", ["order_id"], name: "index_friends_on_order_id", using: :btree

  create_table "items", force: :cascade do |t|
    t.string   "type",        limit: 255
    t.string   "brand",       limit: 255
    t.string   "style",       limit: 255
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.datetime "deleted_at"
    t.integer  "color_id",    limit: 4
    t.string   "color",       limit: 255
    t.integer  "customer_id", limit: 4
    t.integer  "scale",       limit: 4,   default: 0
    t.string   "version",     limit: 255
  end

  add_index "items", ["brand"], name: "index_items_on_brand", using: :btree
  add_index "items", ["customer_id"], name: "index_items_on_customer_id", using: :btree
  add_index "items", ["deleted_at"], name: "index_items_on_deleted_at", using: :btree
  add_index "items", ["style"], name: "index_items_on_style", using: :btree
  add_index "items", ["type"], name: "index_items_on_type", using: :btree

  create_table "maintain_parts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "deleted_at", limit: 4
  end

  add_index "maintain_parts", ["deleted_at"], name: "index_maintain_parts_on_deleted_at", using: :btree

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", limit: 4,    null: false
    t.integer  "application_id",    limit: 4,    null: false
    t.string   "token",             limit: 255,  null: false
    t.integer  "expires_in",        limit: 4,    null: false
    t.string   "redirect_uri",      limit: 2048, null: false
    t.datetime "created_at",                     null: false
    t.datetime "revoked_at"
    t.string   "scopes",            limit: 255
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id", limit: 4
    t.integer  "application_id",    limit: 4,   null: false
    t.string   "token",             limit: 255, null: false
    t.string   "refresh_token",     limit: 255
    t.integer  "expires_in",        limit: 4
    t.datetime "revoked_at"
    t.datetime "created_at",                    null: false
    t.string   "scopes",            limit: 255
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",         limit: 255,               null: false
    t.string   "uid",          limit: 255,               null: false
    t.string   "secret",       limit: 255,               null: false
    t.string   "redirect_uri", limit: 2048,              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "scopes",       limit: 255,  default: "", null: false
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "order_logs", force: :cascade do |t|
    t.integer  "order_id",       limit: 4
    t.integer  "user_id",        limit: 4
    t.string   "attrs",          limit: 255
    t.string   "handle_type",    limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.text     "changed_values", limit: 65535
    t.datetime "deleted_at"
  end

  add_index "order_logs", ["deleted_at"], name: "index_order_logs_on_deleted_at", using: :btree
  add_index "order_logs", ["order_id"], name: "index_order_logs_on_order_id", using: :btree
  add_index "order_logs", ["user_id"], name: "index_order_logs_on_user_id", using: :btree

  create_table "order_statuses", force: :cascade do |t|
    t.integer  "status",      limit: 4, default: 2
    t.integer  "order_id",    limit: 4
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "last_status", limit: 4
    t.integer  "user_id",     limit: 4
    t.boolean  "forward",     limit: 1, default: true
    t.datetime "deleted_at"
  end

  add_index "order_statuses", ["deleted_at"], name: "index_order_statuses_on_deleted_at", using: :btree
  add_index "order_statuses", ["order_id"], name: "index_order_statuses_on_order_id", using: :btree
  add_index "order_statuses", ["user_id"], name: "index_order_statuses_on_user_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.string   "number",                limit: 255
    t.date     "fetch_date"
    t.integer  "store_id",              limit: 4,     default: 1,     null: false
    t.integer  "customer_id",           limit: 4,                     null: false
    t.date     "delivery_date"
    t.integer  "delivery_manner",       limit: 4,     default: 0
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "address_id",            limit: 4
    t.datetime "deleted_at"
    t.integer  "status",                limit: 4,     default: 0
    t.integer  "maintain_part_id",      limit: 4
    t.integer  "service_id",            limit: 4
    t.integer  "flaw_id",               limit: 4
    t.integer  "badness_id",            limit: 4
    t.integer  "item_id",               limit: 4
    t.boolean  "urgent",                limit: 1,     default: false
    t.string   "maintain_part",         limit: 255,   default: ""
    t.string   "flaw",                  limit: 255,   default: ""
    t.string   "badness",               limit: 255,   default: ""
    t.string   "attachment",            limit: 255,   default: ""
    t.integer  "consumption_record_id", limit: 4
    t.string   "color",                 limit: 255
    t.string   "service_ids",           limit: 255,   default: ""
    t.integer  "pickup_manner",         limit: 4,     default: 0
    t.text     "request",               limit: 65535
    t.integer  "fetch_date_start",      limit: 4
    t.integer  "fetch_date_end",        limit: 4
    t.string   "receive_week",          limit: 255
    t.string   "receive_day",           limit: 255
    t.string   "gift",                  limit: 255
    t.string   "part",                  limit: 255
    t.integer  "delivery_date_start",   limit: 4
    t.integer  "delivery_date_end",     limit: 4
    t.string   "delivery_week",         limit: 255
    t.string   "delivery_day",          limit: 255
    t.date     "finish_date"
    t.date     "buy_date"
    t.string   "source",                limit: 255
    t.integer  "price",                 limit: 4
    t.integer  "discount",              limit: 4
    t.integer  "friend_id",             limit: 4
    t.boolean  "paid",                  limit: 1,     default: false
    t.string   "material",              limit: 255
    t.string   "craft",                 limit: 255
    t.string   "version",               limit: 255
    t.string   "symptom",               limit: 255
    t.string   "level",                 limit: 255
    t.string   "position",              limit: 255
    t.string   "fetch_date_detail",     limit: 255
    t.integer  "fetch_address_id",      limit: 4
    t.integer  "delivery_address_id",   limit: 4
    t.string   "delivery_date_detail",  limit: 255
    t.integer  "final_price",           limit: 4,     default: 0
    t.integer  "activity_id",           limit: 4
    t.date     "start_work_date"
    t.string   "barcode_file_name",     limit: 255
    t.string   "barcode_content_type",  limit: 255
    t.integer  "barcode_file_size",     limit: 4
    t.datetime "barcode_updated_at"
    t.integer  "settlement_id",         limit: 4
    t.boolean  "cancel",                limit: 1,     default: false
    t.text     "cancel_reason",         limit: 65535
    t.string   "delivery_name",         limit: 255
    t.string   "delivery_phone",        limit: 255
    t.boolean  "refunded",              limit: 1,     default: false
    t.boolean  "compensated",           limit: 1,     default: false
    t.integer  "act_record_id",         limit: 4
    t.integer  "act_price",             limit: 4,     default: 0
    t.boolean  "pre",                   limit: 1,     default: false
    t.text     "diagnose",              limit: 65535
    t.integer  "rework",                limit: 4,     default: 0
    t.text     "rework_reason",         limit: 65535
    t.boolean  "worker_rework",         limit: 1,     default: false
    t.boolean  "solu_rework",           limit: 1,     default: false
    t.boolean  "abnormal",              limit: 1,     default: false
    t.boolean  "auto_distribute",       limit: 1,     default: false
    t.integer  "appointment_id",        limit: 4
    t.boolean  "delivery_trouble",      limit: 1,     default: false
    t.integer  "delivery_trouble_type", limit: 4
    t.string   "delivery_trouble_desc", limit: 255
    t.string   "fetch_hour_start",      limit: 255
    t.string   "fetch_hour_end",        limit: 255
    t.string   "delivery_hour_start",   limit: 255
    t.string   "delivery_hour_end",     limit: 255
    t.integer  "groupon_codes_count",   limit: 4,     default: 0
    t.boolean  "blue_print_passed",     limit: 1
    t.string   "feedback",              limit: 255
    t.integer  "fetcher_id",            limit: 4
    t.integer  "deliverer_id",          limit: 4
    t.datetime "status_updated_at"
  end

  add_index "orders", ["act_record_id"], name: "index_orders_on_act_record_id", using: :btree
  add_index "orders", ["activity_id"], name: "index_orders_on_activity_id", using: :btree
  add_index "orders", ["address_id"], name: "index_orders_on_address_id", using: :btree
  add_index "orders", ["appointment_id"], name: "index_orders_on_appointment_id", using: :btree
  add_index "orders", ["badness_id"], name: "index_orders_on_badness_id", using: :btree
  add_index "orders", ["consumption_record_id"], name: "index_orders_on_consumption_record_id", using: :btree
  add_index "orders", ["deleted_at"], name: "index_orders_on_deleted_at", using: :btree
  add_index "orders", ["deliverer_id"], name: "index_orders_on_deliverer_id", using: :btree
  add_index "orders", ["delivery_address_id"], name: "index_orders_on_delivery_address_id", using: :btree
  add_index "orders", ["delivery_date"], name: "index_orders_on_delivery_date", using: :btree
  add_index "orders", ["fetch_address_id"], name: "index_orders_on_fetch_address_id", using: :btree
  add_index "orders", ["fetch_date"], name: "index_orders_on_fetch_date", using: :btree
  add_index "orders", ["fetcher_id"], name: "index_orders_on_fetcher_id", using: :btree
  add_index "orders", ["flaw_id"], name: "index_orders_on_flaw_id", using: :btree
  add_index "orders", ["friend_id"], name: "index_orders_on_friend_id", using: :btree
  add_index "orders", ["item_id"], name: "index_orders_on_item_id", using: :btree
  add_index "orders", ["maintain_part_id"], name: "index_orders_on_maintain_part_id", using: :btree
  add_index "orders", ["number"], name: "index_orders_on_number", using: :btree
  add_index "orders", ["pre"], name: "index_orders_on_pre", using: :btree
  add_index "orders", ["rework"], name: "index_orders_on_rework", using: :btree
  add_index "orders", ["service_id"], name: "index_orders_on_service_id", using: :btree
  add_index "orders", ["settlement_id"], name: "index_orders_on_settlement_id", using: :btree
  add_index "orders", ["status"], name: "index_orders_on_status", using: :btree
  add_index "orders", ["status_updated_at"], name: "index_orders_on_status_updated_at", using: :btree
  add_index "orders", ["store_id"], name: "index_orders_on_store_id", using: :btree
  add_index "orders", ["urgent"], name: "index_orders_on_urgent", using: :btree

  create_table "orders_solu_templates", id: false, force: :cascade do |t|
    t.integer "order_id",         limit: 4
    t.integer "solu_template_id", limit: 4
  end

  add_index "orders_solu_templates", ["order_id", "solu_template_id"], name: "index_orders_solu_templates_on_order_id_and_solu_template_id", using: :btree

  create_table "overdues", force: :cascade do |t|
    t.date     "original_date"
    t.date     "expected_date"
    t.string   "reason",        limit: 255
    t.integer  "operator_id",   limit: 4
    t.integer  "order_id",      limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "overdues", ["order_id"], name: "index_overdues_on_order_id", using: :btree

  create_table "pay_records", force: :cascade do |t|
    t.integer  "pm",            limit: 4
    t.integer  "amount",        limit: 4
    t.text     "content",       limit: 65535
    t.integer  "member_id",     limit: 4
    t.integer  "settlement_id", limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "pay_records", ["settlement_id"], name: "index_pay_records_on_settlement_id", using: :btree

  create_table "photo_descs", force: :cascade do |t|
    t.text     "content",      limit: 65535
    t.string   "tags",         limit: 255
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "dtype",        limit: 4,     default: 0
    t.string   "category_ids", limit: 255
    t.string   "symptom",      limit: 255
    t.string   "technology",   limit: 255
    t.string   "expect",       limit: 255
  end

  add_index "photo_descs", ["dtype"], name: "index_photo_descs_on_dtype", using: :btree
  add_index "photo_descs", ["tags"], name: "index_photo_descs_on_tags", using: :btree

  create_table "photo_symptoms", force: :cascade do |t|
    t.string   "symptoms",     limit: 255
    t.integer  "photo_id",     limit: 4
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "categoty_id",  limit: 4
    t.string   "category_ids", limit: 255
    t.text     "desc",         limit: 65535
    t.boolean  "stype",        limit: 1,     default: false
  end

  add_index "photo_symptoms", ["categoty_id"], name: "index_photo_symptoms_on_categoty_id", using: :btree
  add_index "photo_symptoms", ["photo_id"], name: "index_photo_symptoms_on_photo_id", using: :btree
  add_index "photo_symptoms", ["stype"], name: "index_photo_symptoms_on_stype", using: :btree

  create_table "photos", force: :cascade do |t|
    t.string   "photo_file_name",    limit: 255
    t.string   "photo_content_type", limit: 255
    t.integer  "photo_file_size",    limit: 4
    t.datetime "photo_updated_at"
    t.integer  "order_id",           limit: 4
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "desc_id",            limit: 4
    t.integer  "parent_id",          limit: 4
    t.integer  "photoable_id",       limit: 4
    t.string   "photoable_type",     limit: 255
    t.boolean  "header",             limit: 1,   default: true
    t.integer  "sequence",           limit: 4,   default: 0
    t.boolean  "used",               limit: 1,   default: true
    t.string   "media_id",           limit: 255
    t.string   "media_url",          limit: 255
    t.boolean  "front",              limit: 1
  end

  add_index "photos", ["desc_id"], name: "index_photos_on_desc_id", using: :btree
  add_index "photos", ["order_id"], name: "index_photos_on_order_id", using: :btree
  add_index "photos", ["parent_id"], name: "index_photos_on_parent_id", using: :btree
  add_index "photos", ["photoable_id"], name: "index_photos_on_photoable_id", using: :btree
  add_index "photos", ["used"], name: "index_photos_on_used", using: :btree

  create_table "provinces", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "quality_testings", force: :cascade do |t|
    t.integer  "technology_id", limit: 4
    t.integer  "tester_id",     limit: 4
    t.boolean  "qualified",     limit: 1,     default: false
    t.text     "remark",        limit: 65535
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.boolean  "refer",         limit: 1,     default: false
    t.integer  "order_id",      limit: 4
  end

  add_index "quality_testings", ["order_id"], name: "index_quality_testings_on_order_id", using: :btree
  add_index "quality_testings", ["technology_id"], name: "index_quality_testings_on_technology_id", using: :btree
  add_index "quality_testings", ["tester_id"], name: "index_quality_testings_on_tester_id", using: :btree

  create_table "recharges", force: :cascade do |t|
    t.integer  "amount",      limit: 4,     default: 0
    t.integer  "bonus",       limit: 4,     default: 0
    t.integer  "customer_id", limit: 4
    t.text     "content",     limit: 65535
    t.integer  "pm",          limit: 4
    t.integer  "user_id",     limit: 4
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "discount",    limit: 4,     default: 100
  end

  add_index "recharges", ["customer_id"], name: "index_recharges_on_customer_id", using: :btree
  add_index "recharges", ["user_id"], name: "index_recharges_on_user_id", using: :btree

  create_table "refunds", force: :cascade do |t|
    t.integer  "pm",         limit: 4
    t.integer  "rtype",      limit: 4
    t.integer  "amount",     limit: 4
    t.integer  "order_id",   limit: 4
    t.text     "reason",     limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "refunds", ["order_id"], name: "index_refunds_on_order_id", using: :btree

  create_table "services", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "price",      limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "deleted_at", limit: 4
  end

  add_index "services", ["deleted_at"], name: "index_services_on_deleted_at", using: :btree

  create_table "settlements", force: :cascade do |t|
    t.integer  "amount",      limit: 4
    t.integer  "customer_id", limit: 4
    t.integer  "user_id",     limit: 4
    t.integer  "order_id",    limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.datetime "deleted_at"
    t.string   "user_name",   limit: 255
  end

  add_index "settlements", ["customer_id"], name: "index_settlements_on_customer_id", using: :btree
  add_index "settlements", ["deleted_at"], name: "index_settlements_on_deleted_at", using: :btree
  add_index "settlements", ["order_id"], name: "index_settlements_on_order_id", using: :btree
  add_index "settlements", ["user_id"], name: "index_settlements_on_user_id", using: :btree

  create_table "solu_templates", force: :cascade do |t|
    t.text     "header",     limit: 65535
    t.text     "footer",     limit: 65535
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.boolean  "before",     limit: 1,     default: true
  end

  create_table "stores", force: :cascade do |t|
    t.string   "name",       limit: 255, default: ""
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.datetime "deleted_at"
  end

  add_index "stores", ["deleted_at"], name: "index_stores_on_deleted_at", using: :btree

  create_table "technologies", force: :cascade do |t|
    t.integer  "ttype",       limit: 4
    t.integer  "order_id",    limit: 4
    t.text     "remark",      limit: 65535
    t.datetime "end_time"
    t.integer  "user_id",     limit: 4
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.boolean  "repeated",    limit: 1,     default: false
    t.boolean  "substituted", limit: 1,     default: false
  end

  add_index "technologies", ["order_id"], name: "index_technologies_on_order_id", using: :btree
  add_index "technologies", ["user_id"], name: "index_technologies_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255, default: "",    null: false
    t.string   "type",                   limit: 255
    t.string   "phone",                  limit: 255, default: "",    null: false
    t.string   "email",                  limit: 255, default: "",    null: false
    t.boolean  "is_member",              limit: 1,   default: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name",       limit: 255
    t.string   "avatar_content_type",    limit: 255
    t.integer  "avatar_file_size",       limit: 4
    t.datetime "avatar_updated_at"
    t.integer  "store_id",               limit: 4
    t.boolean  "gender",                 limit: 1,   default: false
    t.string   "weixin",                 limit: 255, default: ""
    t.datetime "deleted_at"
    t.integer  "raw_balance",            limit: 4,   default: 0
    t.float    "discount",               limit: 24,  default: 1.0
    t.date     "birthday"
    t.string   "weixin_nickname",        limit: 255
    t.string   "job",                    limit: 255
    t.string   "source",                 limit: 255, default: ""
    t.integer  "service_number",         limit: 4
    t.integer  "sensitivity",            limit: 4
    t.string   "tags",                   limit: 255
    t.boolean  "approved",               limit: 1,   default: false
    t.integer  "ttype",                  limit: 4
    t.string   "sub_source",             limit: 255
  end

  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["gender"], name: "index_users_on_gender", using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["phone"], name: "index_users_on_phone", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["source"], name: "index_users_on_source", using: :btree
  add_index "users", ["store_id"], name: "index_users_on_store_id", using: :btree
  add_index "users", ["type"], name: "index_users_on_type", using: :btree

  create_table "wechat_tokens", force: :cascade do |t|
    t.string   "access_token",      limit: 255
    t.integer  "expires_in",        limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "refresh_token",     limit: 255
    t.string   "openid",            limit: 255
    t.string   "scope",             limit: 255
    t.string   "unionid",           limit: 255
    t.integer  "weixin_account_id", limit: 4
  end

  add_index "wechat_tokens", ["weixin_account_id"], name: "index_wechat_tokens_on_weixin_account_id", using: :btree

  create_table "weixin_accounts", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "code",       limit: 255
    t.string   "openid",     limit: 255
    t.text     "user_info",  limit: 65535
  end

  add_index "weixin_accounts", ["code"], name: "index_weixin_accounts_on_code", using: :btree
  add_index "weixin_accounts", ["user_id"], name: "index_weixin_accounts_on_user_id", using: :btree

  add_foreign_key "order_statuses", "users"
  add_foreign_key "overdues", "orders"
end
