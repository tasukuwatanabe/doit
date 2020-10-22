class AccountActivationsController < ApplicationController
  skip_before_action :logged_in_user

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = 'アカウントが有効化されました'
      redirect_to user
    else
      flash[:danger] = '有効化リンクが有効ではありません'
      redirect_to signup_path
    end
  end
end
