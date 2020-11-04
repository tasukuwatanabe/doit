FactoryBot.define do
  factory :todo_parent do
    user_id { User.first.id }
  end
end
