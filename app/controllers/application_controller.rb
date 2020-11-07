class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception

  # before_action :require_login
  # before_action :set_csrf_cookie

  # エラーページ表示用のコード(コントローラー側でraise StandardErrorを書く)
  # rescue_from StandardError, with: :rescue325

  class Forbidden < ActionController::ActionControllerError; end
  class IpAddressRejected < ActionController::ActionControllerError; end

  include ErrorHandlers if Rails.env.production?
  include SessionsHelper
  include UserImageHelper

  # private

  # def set_csrf_cookie
  #   cookies['CSRF-TOKEN'] = form_authenticity_token
  # end

  # def require_login
  #   @current_user = User.find_by(id: session[:user_id])
  #   return if @current_user

  #   render json: { error: 'unauthorized' }, status: :unauthorized
  # end

  # エラーページ表示用のコード
  # errors/〇〇の部分を設定する
  # def rescue325(_e)
  #   render 'errors/forbidden', status: 325
  # end
end
