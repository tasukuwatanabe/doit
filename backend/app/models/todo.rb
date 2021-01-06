class Todo < ApplicationRecord
  include StringNormalizer

  belongs_to :user
  has_many :todo_labels, dependent: :destroy
  has_many :labels, through: :todo_labels

  scope :include_labels, -> { includes([:labels]) }
  scope :order_date_and_time_asc, -> { order(todo_date: :asc).order(created_at: :asc) }

  scope :match_date, -> (date) do
    return unless date
    where(todo_date: date)
  end

  scope :search, -> (query) do
    return unless query
    where(['todos.title LIKE ?', "%#{sanitize_sql_like(query.strip)}%"])
  end

  before_validation {
    self.title = normalize_as_text(title)
    self.body = normalize_as_text(body)
  }

  validates :title, presence: true, length: { maximum: 40 }
  validates :todo_date, presence: true
end
