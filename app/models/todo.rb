class Todo < ApplicationRecord
  include StringNormalizer

  belongs_to :user
  has_many :todo_labels, dependent: :destroy
  has_many :labels, through: :todo_labels

  before_validation { self.title = normalize_as_text(title) }

  validates :title, presence: true
  validates :todo_date, presence: true, date: {
    after_or_equal_to: Date.new(2000, 1, 1),
    before: ->(_obj) { 1.year.from_now.to_date },
    allow_blank: true
  }

  def self.search(query)
    return nil unless query.present?

    Todo.where(['title LIKE ?', "%#{query.strip}%"]).order(todo_date: :asc)
  end
end
