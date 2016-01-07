# create_table "oauth_applications", force: :cascade do |t|
#   t.string   "name",         limit: 255,               null: false
#   t.string   "uid",          limit: 255,               null: false
#   t.string   "secret",       limit: 255,               null: false
#   t.string   "redirect_uri", limit: 2048,              null: false
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.string   "scopes",       limit: 255,  default: "", null: false
# end

FactoryGirl.define do
  factory :app, class: Doorkeeper::Application do
    name "iOS application"
    uid "e3b35d8e65f6c6eeb4024e38318efd78b2baabf1ce995ad7a0707f3899958545"
    secret "8568e7a88cf2717dc4963d9b321a36884dd9cb3b158423a2e49942e7989d72d8"
    redirect_uri "http://baozheng.com:3000"
  end
end
