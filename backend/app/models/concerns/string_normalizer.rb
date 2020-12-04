require 'nkf'

module StringNormalizer
  extend ActiveSupport::Concern

  def normalize_as_text(text)
    NKF.nkf('-W -w -Z1', text).strip if text
  end

  def normalize_as_email(text)
    NKF.nkf('-W -w -Z1', text).strip if text
  end

  def normalize_as_color(color)
    if color
      color_array = color.split('')
      color_array.shift
      color_array.each do |str|
        str.downcase!
      end
      color_array.unshift('#')
      color_array.join
    end
  end
end
