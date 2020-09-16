require 'date'

module DateCalculationHelper
  def get_the_date
    the_date = Date.parse(request.path.gsub('/', '')).strftime('%Y年%1m月%1d日')
  end

  def set_previous_date
    previous_date = Date.parse(request.path.gsub('/', '')).yesterday
  end

  def set_next_date
    next_date = Date.parse(request.path.gsub('/', '')).tomorrow
  end
end
