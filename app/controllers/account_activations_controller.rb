class AccountActivationsController < ApplicationController
  skip_before_action :logged_in_user

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      flash[:success] = 'アカウントが有効化されました'
      redirect_to login_path
    else
      flash[:danger] = '有効化リンクが無効です'
      redirect_to signup_path
    end
  end
end
