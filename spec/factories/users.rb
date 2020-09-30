FactoryBot.define do
  factory :user do
    username { 'testuser' }
    email { 'testemail@example.com' }
    password { 'password' }
  end
end
