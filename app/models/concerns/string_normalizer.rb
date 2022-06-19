require 'nkf'

module StringNormalizer
  extend ActiveSupport::Concern

  def normalize_as_text(text)
    NKF.nkf('-W -w -Z1', text).strip if text
  end
end