require 'nkf'

module StringNormalizer
  extend ActiveSupport::Concern

  def remove_space(text)
    NKF.nkf('-W -w -Z1', text).strip if text
  end
end
