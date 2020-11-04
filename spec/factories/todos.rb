FactoryBot.define do
  factory :todo do
    title { 'todoタイトル' }
    todo_date { Date.today }
    start_date { Date.today }
    end_date { Date.today }
    user_id { User.first.id }
    todo_parent_id { TodoParent.first.id }
  end
end
