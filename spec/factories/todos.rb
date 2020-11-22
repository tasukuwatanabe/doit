FactoryBot.define do
  factory :todo do
    association :user
    title { 'Todoタイトル' }
    todo_date { Date.today }
    label_id { Label.first.id }
  end
end
