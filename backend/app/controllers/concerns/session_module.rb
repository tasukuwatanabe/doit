module SessionModule
  extend ActiveSupport::Concern

  def log_in(user)
    return unless user.activated?
    user.remember!
    cookies.permanent.signed[:user_id] = {
      value: user.id,
      domain: 'doit-plan.com'
    }
    cookies.permanent[:remember_token] = {
      value: user.remember_token,
      domain: 'doit-plan.com'
    }
  end

  def log_out
    cookies.delete(:user_id, domain: 'doit-plan.com') if cookies[:user_id]
    cookies.delete(:remember_token, domain: 'doit-plan.com')
  end
end
