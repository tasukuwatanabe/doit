class ApplicationController < ActionController::Base
  before_action :get_today
  before_action :request_path

  class Forbidden < ActionController::ActionControllerError; end
  class IpAddressRejected < ActionController::ActionControllerError; end

  include ErrorHandlers if Rails.env.production?
  include SessionsHelper

  private

  def get_today
    @today = Date.today.strftime('%Y-%m-%d')
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'ログインが必要です'
      redirect_to login_path
    end
  end

  def request_path
    @path = controller_path + '#' + action_name
    def @path.is(*str)
      str.map { |s| include?(s) }.include?(true)
    end
  end
end
