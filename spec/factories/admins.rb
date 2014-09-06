# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin do
    email 'test@test.com'
    password 'pw4test'
  end
end
