FactoryBot.define do
  factory :event do
    name { "gugu" }
    description { "hehehe" }
    location { "delhi" }
    time { 1.day.from_now }
    capacity { 100 }
    cancelled { false }
    organizer { association :user }
  end
end
