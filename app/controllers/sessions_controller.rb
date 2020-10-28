class SessionsController < ApplicationController
  skip_before_action :logged_in_user, except: :destroy
  before_action :forbid_login_user, only: %i[new create guest_login]

  def new
    @form = LoginForm.new
  end

  def create
    auth = request.env['omniauth.auth']
    puts auth
    if auth.present?
      user = User.find_or_create_from_oauth(auth)
      if user.present?
        log_in user
        flash[:success] = 'ログインしました'
        redirect_to root_path
      else
        flash[:danger] = '認証に失敗しました'
        redirect_to login_path
      end
    else
      @form = LoginForm.new(login_form_params)
      user = User.find_by('LOWER(email) = ?', @form.email.downcase) if @form.email.present?

      if Authenticator.new(user).authenticate(@form.password)
        if user.activated?
          log_in user
          @form.remember_me? ? remember(user) : forget(user)
          flash[:success] = 'ログインしました。'
          redirect_to root_path
        else
          flash[:danger] = 'アカウントが有効ではありません'
          redirect_to login_path
        end
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
    redirect_to todo_index_path(@today)
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
