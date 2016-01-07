FactoryGirl.define do
  factory :courier, class: Courier do
    approved true

    name "test couriers"
    phone "18001257140"
    email "courier@baozheng.cc"

    password "password"
    password_confirmation "password"
  end
end
