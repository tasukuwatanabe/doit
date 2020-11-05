require 'date'

module CalculationDateHelper
  def date_out_of_range?(date)
    date < Date.new(2000, 1, 1) || date > 1.year.from_now.to_date
  end

  def get_today
    Date.today.strftime('%Y年%1m月%1d日')
  end

  def get_url_date
    Date.parse(params[:date])
  end

  def format_todo_date(todo_date)
    todo_date.strftime('%Y年%1m月%1d日')
  end

  def get_url_date_in_japanese
    get_url_date.strftime('%Y年%1m月%1d日')
  end

  def get_day
    %w[日 月 火 水 木 金 土][get_url_date.wday] + '曜日'
  end

  def set_previous_date
    if !date_out_of_range?(get_url_date.yesterday)
      get_url_date.yesterday
    else
      false
    end
  end

  def set_next_date
    if !date_out_of_range?(get_url_date.tomorrow)
      get_url_date.tomorrow
    else
      false
    end
  end
end
