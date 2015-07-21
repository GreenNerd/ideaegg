FactoryGirl.define do
  factory :feedback do
    body Forgery('email').body
    stars rand(6)
    images ['http://test']
    contact Forgery('internet').email_address
  end
end
