class Label < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, allow_blank: true, uniqueness: true
  validates :color, presence: true, allow_blank: true
  validate :is_color

  def is_color
    color_array = color.split('')
    string_array = (0..9).to_a.map(&:to_s) + ('a'..'f').to_a

    errors.add(:color, 'エラー') unless color_array.length == 6 && color_array.all? { |i| string_array.include?(i) }
  end
end
