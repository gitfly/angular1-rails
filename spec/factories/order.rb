FactoryGirl.define do
  factory :order do
    number "201507192355052"
    association :store, factory: :store
    association :customer, factory: :customer
  end
end
