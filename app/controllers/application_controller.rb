class ApplicationController < ActionController::Base
  before_action :set_date
  before_action :request_path

  include SessionsHelper
  include DateCalculationHelper

  def get_shortcuts
    @shortcuts = Shortcut.where(user_id: current_user.id)
  end

  def set_date
    @today = Date.today.strftime('%Y-%m-%d')
  end

  def request_path
    @path = controller_path + '#' + action_name
    def @path.is(*str)
      str.map { |s| include?(s) }.include?(true)
    end
  end

  private def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'ログインが必要です'
      redirect_to login_path
    end
  end
end
