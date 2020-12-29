class Label < ApplicationRecord
  include StringNormalizer

  belongs_to :user
  has_many :todo_labels, dependent: :destroy
  has_many :todos, through: :todo_labels
  has_many :shortcut_labels, dependent: :destroy
  has_many :shortcuts, through: :shortcut_labels

  scope :recent, -> { order(created_at: :desc) }

  before_validation :normalize_text

  before_save :color_downcase!

  validates :title, presence: true,
                    uniqueness: { scope: :user },
                    length: { maximum: 30 }
  validates :color, presence: true,
                    format: { with: /\A#?(?:[A-F0-9]{3}){1,2}\z/i }
  validate :user_label_count_within_limit

  private

  def normalize_text
    self.title = normalize_as_text(title)
    self.color = normalize_as_text(color)
  end

  def color_downcase!
    color.downcase!
  end

  def user_label_count_within_limit
    errors.add(:labels, count: I18n.t("errors.messages.exceed")) if user.labels.size > 10
  end
end
