FactoryBot.define do
  factory :user do
    username { "dsasssdsa" }
    email { "sdsas@email.com" }
    password { 'password123' }
    role { 1 }
    first_name { "first_name" }
    last_name { "last_name" }
    active { true }
  end
end
