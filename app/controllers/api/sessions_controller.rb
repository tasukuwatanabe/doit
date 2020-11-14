class Api::SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  include SessionsHelper

  def create
    user = User.find_by('LOWER(email) = ?', session_params[:email].downcase) if session_params[:email].present?

    if Authenticator.new(user).authenticate(session_params[:password])
      if user.activated?
        log_in user
        puts 'ログインしました'
      else
        puts 'メールアドレスまたはパスワードが間違えています'
      end
    end
  end

  def guest_login
    user = User.find_by(email: 'guest@example.com')
    log_in user
    puts 'ログインしました'
  end

  def destroy
    log_out
    puts 'ログアウトしました'
  end

  private def session_params
    params.fetch(:session, {}).permit(:id, :email, :password)
  end
end
