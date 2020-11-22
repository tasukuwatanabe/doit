FactoryBot.define do
  factory :shortcut do
    association :user
    title { 'ショートカットタイトル' }
    label_id { Label.first.id }
  end
end
