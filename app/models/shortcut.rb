class Shortcut < ApplicationRecord
  include StringNormalizer

  belongs_to :user

  before_validation do
    self.title = normalize_as_text(title)
  end

  validate :shortcut_counts_must_be_within_limit
  validates :title, presence: true, uniqueness: {
    scope: :user,
    message: 'タイトルが重複しています'
  }

  def shortcut_counts_must_be_within_limit
    errors.add(:base, 'ショートカットが登録できるのは10個までです') if user && user.shortcuts.size > 10
  end
end
