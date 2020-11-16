FactoryBot.define do
  factory :user do
    username { 'testuser' }
    email { 'testemail@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
    activated { true }
    activated_at { Time.zone.now }
  end
end
