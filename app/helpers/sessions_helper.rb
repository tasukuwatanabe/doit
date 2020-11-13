module SessionsHelper
  def log_in(user)
    if user.activated?
      user.remember
      cookies.permanent.signed[:user_id] = user.id
      cookies.permanent[:remember_token] = user.remember_token
    else
      redirect_to root_path
    end
  end

  def current_user?(user)
    user == current_user
  end

  def current_user
    if (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      return user if user&.authenticated?(:remember, cookies[:remember_token])
    end
  end

  def forbid_guest_user
    redirect_to root_path if user_is_guest?
  end

  def user_is_guest?
    current_user.email == 'guest@example.com'
  end

  def disable_for_guest
    'disabled' if user_is_guest?
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
