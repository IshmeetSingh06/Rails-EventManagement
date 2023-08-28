FactoryBot.define do
  factory :user do
    username { "admin" }
    email { "email@email.com" }
    password { 'password123' }
    role { :guest }
    first_name { "first_name" }
    last_name { "last_name" }
    active { true }
  end
end
