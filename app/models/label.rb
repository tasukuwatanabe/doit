class Label < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, uniqueness: true
  validates :color, presence: true
  validate :is_color

  def is_color
    color_array = color.split('')
    color_array.shift
    color_array.each do |c|
      c.downcase!
    end

    num_array = (0..9).to_a.map(&:to_s)
    alphabet_array = ('a'..'f').to_a

    string_array = num_array + alphabet_array

    color_condition = color_array.all? do |i|
      string_array.include?(i)
    end

    errors.add(:color, 'エラー') unless color_array.length == 6 && color_condition
  end
end
