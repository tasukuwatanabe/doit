FactoryBot.define do
  factory :todo do
    title { 'todoタイトル' }
    todo_date { Date.today }
    user_id { User.first.id }
  end
end
