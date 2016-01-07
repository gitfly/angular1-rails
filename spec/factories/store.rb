# create_table "stores", force: :cascade do |t|
#   t.string   "name",       limit: 255, default: ""
#   t.datetime "created_at",                          null: false
#   t.datetime "updated_at",                          null: false
#   t.datetime "deleted_at"
# end

FactoryGirl.define do
  factory :store do
    name "包拯工作室小悦城店"
  end
end
