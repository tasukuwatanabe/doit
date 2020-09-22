require 'date'

module DateCalculationHelper
  def format_date_id(date_id)
    Date.parse(date_id).strftime('%Y年%1m月%1d日')
  end

  def get_url_date
    Date.parse(request.path.gsub('/', ''))
  end

  def get_formatted_url_date
    get_url_date.strftime('%Y年%1m月%1d日')
  end

  def set_previous_date
    get_url_date.yesterday
  end

  def set_next_date
    get_url_date.tomorrow
  end
end
