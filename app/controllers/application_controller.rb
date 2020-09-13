class ApplicationController < ActionController::Base
  before_action :set_date

  include DateCalculationHelper

  def set_date
    @today = Date.today.strftime('%Y-%m-%d')
  end
end
