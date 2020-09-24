class Todo < ApplicationRecord
  include StringNormalizer

  belongs_to :user
  belongs_to :routine, optional: true

  before_validation do
    self.title = remove_space(title)
  end

  validates :title, presence: true

  default_scope -> { order('routine_id is null, routine_id desc, created_at desc') }
end
