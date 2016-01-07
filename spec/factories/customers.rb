FactoryGirl.define do
  factory :customer, class: Customer do
    approved true

    name "test customer"
    phone "18601257149"
    email "customer@baozheng.cc"

    password "password"
    password_confirmation "password"
  end
end
