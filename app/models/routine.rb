class Routine < ApplicationRecord
  include StringNormalizer

  belongs_to :user
  has_many :todos, dependent: :destroy

  before_validation do
    self.title = normalize_as_text(title)
  end

  validates :title, presence: true, uniqueness: true

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

  default_scope -> { order(created_at: :desc) }
end
