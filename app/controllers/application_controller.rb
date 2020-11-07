class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # before_action :logged_in_user
  # before_action :get_today
  # before_action :request_path

  # エラーページ表示用のコード(コントローラー側でraise StandardErrorを書く)
  # rescue_from StandardError, with: :rescue325

  class Forbidden < ActionController::ActionControllerError; end
  class IpAddressRejected < ActionController::ActionControllerError; end

  include ErrorHandlers if Rails.env.production?
  include SessionsHelper
  include UserImageHelper

  private

  def get_today
    @today = Date.today.strftime('%Y-%m-%d')
  end

  def logged_in_user
    # render json: 'ログインしてください'

    # unless logged_in?
    # respond_to do |_format|
    #   format html: { redirect_to: '/login', notice: 'ログインしてください' }
    #   # render json: 'ログインしてください' unless logged_in?
    # end
    # end
  end

  def request_path
    @path = controller_path + '#' + action_name
    def @path.is(*str)
      str.map { |s| include?(s) }.include?(true)
    end
  end

  # エラーページ表示用のコード
  # errors/〇〇の部分を設定する
  # def rescue325(_e)
  #   render 'errors/forbidden', status: 325
  # end
end
