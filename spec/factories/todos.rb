FactoryBot.define do
  factory :todo do
    association :user
    title { 'Todoタイトル' }
    todo_date { Date.today }
  end
end
