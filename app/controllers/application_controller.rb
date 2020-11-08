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

  private

  def logged_in?
    if !current_user.nil?
      render json: { status: 'logged in' }, status: 200
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

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
