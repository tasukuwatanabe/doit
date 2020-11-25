FactoryBot.define do
  factory :todo do
    association :user
    title { 'Todoタイトル' }
    todo_date { Date.today }
    label_ids { [Label.first.id] }
  end
end
