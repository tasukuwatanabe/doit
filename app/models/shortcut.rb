class Shortcut < ApplicationRecord
  include StringNormalizer

  MAX_SHORTCUT_COUNT = 10

  belongs_to :user

  before_validation do
    self.title = normalize_as_text(title)
  end

  validate :shortcut_counts_must_be_within_limit
  validates :title, presence: true, uniqueness: {
    message: 'が他のショートカットと重複しています'
  }

  default_scope -> { order(created_at: :desc) }

  private def shortcut_counts_must_be_within_limit
    if user.shortcuts.count >= MAX_SHORTCUT_COUNT
      errors.add(:base, "ショートカットが登録できるのは#{MAX_SHORTCUT_COUNT}個までです")
    end
  end
end
