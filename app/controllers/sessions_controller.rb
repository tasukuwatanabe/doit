class SessionsController < ApplicationController
  skip_before_action :logged_in_user, except: :destroy
  before_action :forbid_login_user, only: [ :new, :create, :guest_login ]

  def new
    @form = LoginForm.new
  end

  def create
    auth = request.env['omniauth.auth']
    if auth.present?
      user = User.find_or_create_from_oauth(request.env['omniauth.auth'])
      if user.present?
        log_in user
        flash[:success] = 'ログインしました'
        redirect_to root_url
      else
        flash[:danger] = '認証に失敗しました'
        redirect_to login_url
      end
    else

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
  end

  def guest_login
    user = User.find_by!(email: 'guest@example.com')
    log_in(user)
    flash[:success] = 'ゲストユーザーでログインしました。'
    redirect_to index_path(@today)
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
