FactoryBot.define do
  factory :event do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    location { Faker::Address.city }
    time { 1.day.from_now }
    capacity { 100 }
    cancelled { false }
    organizer { association :user }
  end
end
