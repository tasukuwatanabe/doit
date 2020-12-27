FactoryBot.define do
  factory :label do
    association :user
    sequence(:title) { |n| "ラベルタイトル#{n+1}" }
    color { '#FF00BB' }
  end
end
