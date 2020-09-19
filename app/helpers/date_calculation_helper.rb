require 'date'

module DateCalculationHelper
  def get_url_date
    date_parce_url
  end

  def get_url_date_formatted
    date_parce_url.strftime('%Y年%1m月%1d日')
  end

  def set_previous_date
    date_parce_url.yesterday
  end

  def set_next_date
    date_parce_url.tomorrow
  end

  private def date_parce_url
    @url_date = Date.parse(request.path.gsub('/', ''))
  end

  # private_class_method :date_parce_url
end
