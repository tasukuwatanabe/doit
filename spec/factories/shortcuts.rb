FactoryBot.define do
  factory :shortcut do
    title { 'shortcutタイトル' }
    user_id { User.find_by(email: 'testemail@example.com').id }
  end
end
