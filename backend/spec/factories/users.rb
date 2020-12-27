token = User.new_token
digest = User.digest(token)

FactoryBot.define do
  factory :user do
    username { 'ユーザー' }
    sequence(:email) { |n| "user#{n}@email.com" }
    sequence(:unconfirmed_email) { |n| "user#{n}_new@email.com" }
    password { 'password' }
    password_confirmation { 'password' }
    activated { true }
    user_image { nil }
    activation_token { token }
    activation_digest { digest }
    confirmation_token { token }
    confirmation_digest { digest }
    confirmation_sent_at { 1.hour.ago }
    reset_token { token }
    reset_digest { digest }
    reset_sent_at { 1.hour.ago }
  end
end
