module SessionsHelper
  def log_in(user)
    if user.activated?
      user.remember
      cookies.permanent.signed[:user_id] = user.id
      cookies.permanent[:remember_token] = user.remember_token
    else
      flash[:danger] = 'アカウントが有効ではありません'
      redirect_to login_path
    end
  end

  def current_user?(user)
    user == current_user
  end

  def current_user
    if (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      @current_user = user if user&.authenticated?(:remember, cookies[:remember_token])
    end
  end

  def forbid_guest_user
    if user_is_guest?
      flash[:danger] = 'ゲストユーザーの変更・削除はできません'
      redirect_to root_path(@today)
    end
  end

  def forbid_login_user
    if logged_in?
      flash[:danger] = 'すでにログインしています'
      redirect_to root_path(@today)
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def user_is_guest?
    current_user.email == 'guest@example.com' if logged_in?
  end

  def disable_for_guest
    'disabled' if user_is_guest?
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def forget(user)
    user.forget if user
    cookies.delete(:user_id) if cookies[:user_id]
    cookies.delete(:remember_token) if cookies[:remember_token]
  end

  def log_out
    forget(current_user)
    @current_user = nil
  end
end
