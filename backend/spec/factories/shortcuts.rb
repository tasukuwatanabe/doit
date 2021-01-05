FactoryBot.define do
  factory :shortcut do
    association :user
    title { Faker::Games::Pokemon.name }
  end
end