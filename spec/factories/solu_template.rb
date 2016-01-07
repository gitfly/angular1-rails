FactoryGirl.define do
  factory :before_template, class: SoluTemplate do
    before true
    header "before template header"
    footer "before template footer"
  end

  factory :after_template, class: SoluTemplate do
    before false
    header "after template header"
    footer "after template footer"
  end
end
