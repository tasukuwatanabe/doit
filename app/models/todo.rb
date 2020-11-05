class Todo < ApplicationRecord
  include StringNormalizer

  belongs_to :user
  belongs_to :routine, optional: true

  before_validation { self.title = normalize_as_text(title) }

  validates :title, presence: true
  validates :todo_date, presence: true, date: {
    after_or_equal_to: Date.new(2000, 1, 1),
    before: ->(_obj) { 1.year.from_now.to_date },
    allow_blank: true
  }
  validates :start_date, presence: true, date: {
    before_or_equal_to: :end_date,
    after_or_equal_to: Date.new(2000, 1, 1),
    before: ->(_obj) { 1.year.from_now.to_date },
    allow_blank: true
  }
  validates :end_date, date: {
    after_or_equal_to: :end_date,
    before: ->(_obj) { 1.year.from_now.to_date },
    allow_blank: true
  }
  validates :todo_parent_id, presence: true

  def self.search(search)
    return nil unless search

    Todo.where(['title LIKE ?', search.to_s])
  end
end
