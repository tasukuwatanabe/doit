FactoryBot.define do
  factory :user do
    username { 'ユーザー' }
    sequence(:email) { |n| "user#{n}@email.com" }
    password { 'password' }
    password_confirmation { 'password' }
    activated { true }
    user_image { nil }
  end
end
