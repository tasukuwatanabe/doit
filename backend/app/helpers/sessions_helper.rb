module SessionsHelper
  def current_user
    return unless user = User.find(cookies.signed[:user_id])
    user if user.authenticated?(:remember, cookies[:remember_token])
  end
end
