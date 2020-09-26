class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user&.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      flash[:success] = 'ログインしました。'
      redirect_back_or root_path
    else
      flash.now[:danger] = 'メールアドレスもしくはパスワードが正しくありません。'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = 'ログアウトしました。'
    redirect_to login_path
  end
end
