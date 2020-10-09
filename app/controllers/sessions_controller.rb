class SessionsController < ApplicationController
  skip_before_action :logged_in_user, except: :destroy
  before_action :forbid_login_user, only: [ :new, :create ]

  def new
    @form = LoginForm.new
  end

  def create
    @form = LoginForm.new(login_form_params)
    if @form.email.present?
      user = User.find_by('LOWER(email) = ?', @form.email.downcase)
    end
    if Authenticator.new(user).authenticate(@form.password)
      log_in user
      if @form.remember_me?
        remember(user)
      else
        forget(user)
        session[:user_id] = user.id
      end
      flash[:success] = 'ログインしました。'
      redirect_back_or index_path(@today)
    else
      flash.now[:danger] = 'メールアドレスまたはパスワードが正しくありません。'
      render action: 'new'
    end
  end

  private def login_form_params
    params.require(:login_form).permit(:email, :password, :remember_me)
  end

  def destroy
    log_out if logged_in?
    flash[:success] = 'ログアウトしました。'
    redirect_to login_path
  end
end
