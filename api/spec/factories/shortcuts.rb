FactoryBot.define do
  factory :shortcut do
    association :user
    sequence(:title) { |n| "ショートカットタイトル#{n}" }
  end
end