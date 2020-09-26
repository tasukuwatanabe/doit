class Todo < ApplicationRecord
  include StringNormalizer

  belongs_to :user
  belongs_to :routine, optional: true

  before_validation do
    self.title = remove_space(title)
  end

  validates :title, presence: true

  validates :todo_date, presence: true, date: {
    after_or_equal_to: :start_date,
    before_or_equal_to: :end_date
  }

  validates :start_date, presence: true, date: {
    after_or_equal_to: Date.new(2000, 1, 1),
    before: ->(_obj) { 1.year.from_now.to_date },
    allow_blank: true
  }
  validates :end_date, date: {
    after_or_equal_to: :start_date,
    before: ->(_obj) { 1.year.from_now.to_date },
    allow_blank: true
  }
end
