class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  # before_action :require_login
  # before_action :logged_in?

  # エラーページ表示用のコード(コントローラー側でraise StandardErrorを書く)
  # rescue_from StandardError, with: :rescue325

  class Forbidden < ActionController::ActionControllerError; end
  class IpAddressRejected < ActionController::ActionControllerError; end

  include ErrorHandlers if Rails.env.production?
  include SessionsHelper
  include UserImageHelper

  # private

  # エラーページ表示用のコード
  # errors/〇〇の部分を設定する
  # def rescue325(_e)
  #   render 'errors/forbidden', status: 325
  # end
end
