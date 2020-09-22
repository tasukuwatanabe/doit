class Routine < ApplicationRecord
  include StringNormalizer

  belongs_to :user
  has_many :task

  before_validation do
    self.title = remove_space(title)
  end

  validates :title, presence: true, uniqueness: true, allow_blank: true
  validates :start_date, presence: true, date: {
    after_or_equal_to: Date.new(2000, 1, 1),
    before: ->(_obj) { 1.year.from_now.to_date },
    allow_blank: true
  }
  validates :end_date, presence: true, date: {
    after: :start_date,
    before: ->(_obj) { 1.year.from_now.to_date },
    allow_blank: true
  }
end
