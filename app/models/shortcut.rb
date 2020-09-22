class Shortcut < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, uniqueness: true

  MAX_SHORTCUT_COUNT = 10

  validate do
    if user.shortcuts.count >= MAX_SHORTCUT_COUNT
      errors.add(:base, "ショートカットが登録できるのは#{MAX_SHORTCUT_COUNT}個までです")
    end
  end
end
