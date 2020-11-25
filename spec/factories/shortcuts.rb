FactoryBot.define do
  factory :shortcut do
    association :user
    title { 'ショートカットタイトル' }
  end
end