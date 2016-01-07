# create_table "users", force: :cascade do |t|
#   t.string   "name",                   limit: 255, default: "",    null: false
#   t.string   "type",                   limit: 255
#   t.string   "phone",                  limit: 255, default: "",    null: false
#   t.string   "email",                  limit: 255, default: "",    null: false
#   t.boolean  "is_member",              limit: 1,   default: false
#   t.string   "encrypted_password",     limit: 255, default: "",    null: false
#   t.string   "reset_password_token",   limit: 255
#   t.datetime "reset_password_sent_at"
#   t.datetime "remember_created_at"
#   t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
#   t.datetime "current_sign_in_at"
#   t.datetime "last_sign_in_at"
#   t.string   "current_sign_in_ip",     limit: 255
#   t.string   "last_sign_in_ip",        limit: 255
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.string   "avatar_file_name",       limit: 255
#   t.string   "avatar_content_type",    limit: 255
#   t.integer  "avatar_file_size",       limit: 4
#   t.datetime "avatar_updated_at"
#   t.integer  "store_id",               limit: 4
#   t.boolean  "gender",                 limit: 1,   default: false
#   t.string   "weixin",                 limit: 255, default: ""
#   t.datetime "deleted_at"
#   t.integer  "raw_balance",            limit: 4,   default: 0
#   t.float    "discount",               limit: 24,  default: 1.0
#   t.date     "birthday"
#   t.string   "weixin_nickname",        limit: 255
#   t.string   "job",                    limit: 255
#   t.integer  "source",                 limit: 4,   default: 0
#   t.integer  "service_number",         limit: 4
#   t.integer  "sensitivity",            limit: 4
#   t.string   "tags",                   limit: 255
#   t.boolean  "approved",               limit: 1,   default: false
# end

FactoryGirl.define do
  factory :admin, class: User, aliases: [:resource_owner] do
    type "Admin"
    approved true

    name "test user"
    phone "18601257148"
    email "test@baozheng.cc"

    password "password"
    password_confirmation "password"
  end
end
