FactoryBot.define do
  factory :todo do
    association :user
    title { Faker::Games::Pokemon.name }
    todo_date { Date.today }
    status { false }
  end
end
