module SessionModule
  extend ActiveSupport::Concern

  def log_in(user)
    return unless user.activated?
    user.remember!
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def log_out
    cookies.delete(:user_id) if cookies[:user_id]
    cookies.delete(:remember_token)
  end
end