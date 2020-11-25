FactoryBot.define do
  factory :shortcut do
    association :user
    title { 'ショートカットタイトル' }
    label_ids { [Label.first.id] }
  end
end