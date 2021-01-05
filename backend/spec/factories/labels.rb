FactoryBot.define do
  factory :label do
    association :user
    title { Faker::Games::Pokemon.name }
    color { '#FF00BB' }
  end
end
