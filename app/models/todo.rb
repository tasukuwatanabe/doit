class Todo < ApplicationRecord
  include StringNormalizer

  belongs_to :user
  belongs_to :routine, optional: true

  before_validation { self.title = normalize_as_text(title) }

  validates :title, presence: true
  validates :todo_date, presence: true

  default_scope -> { order('routine_id is null, routine_id desc, created_at desc') }
end
