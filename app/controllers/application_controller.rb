class ApplicationController < ActionController::Base
  before_action :set_date

  include SessionsHelper
  include DateCalculationHelper

  def set_date
    @today = Date.today.strftime('%Y-%m-%d')
  end

  private def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'ログインが必要です'
      redirect_to login_path
    end
  end
end
