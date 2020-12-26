FactoryBot.define do
  factory :user do
    username { 'ユーザー' }
    sequence(:email) { |n| "user#{n}@email.com" }
    sequence(:unconfirmed_email) { |n| "user#{n}_new@email.com" }
    password { 'password' }
    password_confirmation { 'password' }
    activated { true }
  end
end
