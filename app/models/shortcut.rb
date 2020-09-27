class Shortcut < ApplicationRecord
  include StringNormalizer

  belongs_to :user

  before_validation do
    self.title = remove_space(title)
  end

  validates :title, presence: true, uniqueness: true

  MAX_SHORTCUT_COUNT = 10

  validate do
    if user.shortcuts.count > MAX_SHORTCUT_COUNT
      errors.add(:base, "ショートカットが登録できるのは#{MAX_SHORTCUT_COUNT}個までです")
    end
  end

  default_scope -> { order(created_at: :desc) }
end
