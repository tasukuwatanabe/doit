require 'date'

module CalculationMonthHelper
  def month_out_of_range?(month)
    month < Date.new(2000, 1, 1) || month > Date.today
  end

  def set_this_month
    year = Date.today.year
    month = Date.today.month
    "#{year}-#{month}"
  end

  def set_previous_month
    params_array = params[:month].split('-').map(&:to_i)
    params_year = params_array[0]
    params_month = params_array[1]

    previous_month = Date.new(params_year, params_month, 1) - 1.month
    unless month_out_of_range?(previous_month)
      year = previous_month.year
      month = previous_month.month.to_s.rjust(2, '0')
      "#{year}-#{month}"
    end
  end

  def set_next_month
    params_array = params[:month].split('-').map(&:to_i)
    params_year = params_array[0]
    params_month = params_array[1]

    next_month = Date.new(params_year, params_month, 1) + 1.month
    unless next_month > Date.today
      year = next_month.year
      month = next_month.month.to_s.rjust(2, '0')
      "#{year}-#{month}"
    end
  end
end
