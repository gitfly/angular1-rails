# create_table "oauth_access_tokens", force: :cascade do |t|
#   t.integer  "resource_owner_id", limit: 4
#   t.integer  "application_id",    limit: 4,   null: false
#   t.string   "token",             limit: 255, null: false
#   t.string   "refresh_token",     limit: 255
#   t.integer  "expires_in",        limit: 4
#   t.datetime "revoked_at"
#   t.datetime "created_at",                    null: false
#   t.string   "scopes",            limit: 255
# end

FactoryGirl.define do
  factory :access_token, class: Doorkeeper::AccessToken do
    association :application, factory: :app
    token "e13798e17163d98e12533734b38b715046c863d5c9a53612f2297b1d624c4ca4"
    expires_in 86400
  end
end
