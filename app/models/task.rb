class Task < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, uniqueness: { scope: [:date_id, :user_id], message: '指定した日付にはすでに追加済みです' }

  default_scope -> { order(created_at: :desc) }
end
