class Todo < ApplicationRecord
  include StringNormalizer

  belongs_to :user
  has_many :todo_labels, dependent: :destroy
  has_many :labels, through: :todo_labels

  scope :include_labels, -> { includes([:labels]) }
  scope :order_created_asc, -> { order(created_at: :asc) }
  scope :match_date, -> (date) { where(todo_date: date) }
  scope :search, -> (query) { where(['todos.title LIKE ?', "%#{sanitize_sql_like(query.strip)}%"]) }

  before_validation { self.title = normalize_as_text(title) }

  validates :title, presence: true
  validates :todo_date, presence: true, date: {
    after_or_equal_to: Date.new(2000, 1, 1),
    before: ->(_obj) { 1.year.from_now.to_date },
    allow_blank: true
  }
end
