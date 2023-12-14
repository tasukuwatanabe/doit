FactoryBot.define do
  factory :label do
    association :user
    sequence(:title) { |n| "ラベルタイトル#{n}" }
    color { '#FF00BB' }
  end
end
