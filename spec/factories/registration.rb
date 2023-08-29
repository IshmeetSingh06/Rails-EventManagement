FactoryBot.define do
  factory :registration do
    user { association :user }
    event { association :event }
  end
end
