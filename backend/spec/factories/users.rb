token = User.new_token
digest = User.digest(token)
password = Faker::Lorem.characters(number: 20)

FactoryBot.define do
  factory :user do
    username { Faker::Name.first_name }
    email { Faker::Internet.email }
    unconfirmed_email { Faker::Internet.email }
    password { password }
    password_confirmation { password }
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
