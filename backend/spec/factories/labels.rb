FactoryBot.define do
  factory :label do
    association :user
    title { 'ショートカットタイトル' }
    color { '#FF00BB' }
  end
end
