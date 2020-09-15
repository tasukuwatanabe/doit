require 'date'

module DayCalculationHelper
  def set_previous_day
    previous_day = Date.parse(request.path.gsub('/', '')).yesterday
  end

  def set_next_day
    next_day = Date.parse(request.path.gsub('/', '')).tomorrow
  end
end
