FactoryBot.define do
  factory :label do
    association :user
    title { 'ラベルタイトル' }
    color { '#FF00BB' }
  end
end
