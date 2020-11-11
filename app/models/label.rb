class Label < ApplicationRecord
  include StringNormalizer

  belongs_to :user

  before_validation do
    self.title = normalize_as_text(title)
    self.color = normalize_as_color(color)
  end

  validates :title, presence: true, uniqueness: true
  validates :color, presence: true
  validate :label_color_must_be_hex_style
  validate :label_counts_must_be_within_limit

  private def label_color_must_be_hex_style
    hex_string_array = (0..9).to_a.map(&:to_s) + ('a'..'f').to_a

    color_array = color.split('')
    color_array.shift
    color_condition = color_array.all? do |i|
      hex_string_array.include?(i)
    end

    errors.add(:color, 'エラー') unless color_array.length == 6 && color_condition
  end

  private def label_counts_must_be_within_limit
    errors.add(:base, 'ラベルが登録できるのは10個までです') if user.labels.size > 10
  end
end
