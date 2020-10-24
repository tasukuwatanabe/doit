class AccountActivationsController < ApplicationController
  skip_before_action :logged_in_user

  def edit
    user = User.find_by(email: params[:email])
    if user && user.activated?
      flash[:danger] = 'アカウントはすでに有効です'
    elsif user && user.authenticated?(:activation, params[:id])
      user.activate
      flash[:success] = 'アカウントが有効化されました'
    else
      flash[:danger] = '有効化リンクが無効です'
    end
    redirect_to logged_in? ? root_path : login_path
  end
end
