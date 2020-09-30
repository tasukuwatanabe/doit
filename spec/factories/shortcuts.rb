FactoryBot.define do
  factory :shortcut do
    title { 'shortcutタイトル' }
    user_id { User.first.id }
  end
end
