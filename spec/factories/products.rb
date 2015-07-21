FactoryGirl.define do
  factory :product do
    name Forgery('name').company_name
  end
end
