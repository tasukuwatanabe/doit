FactoryBot.define do
  factory :routine do
    title { 'routineタイトル' }
    start_date { Date.yesterday }
    end_date { Date.tomorrow }
    user_id { User.first.id }
  end
end
