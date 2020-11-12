class Api::SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  include SessionsHelper

  def create
    auth = request.env['omniauth.auth']
    if auth.present?
      user = User.find_or_create_from_oauth(auth)
      if user.present?
        log_in user
        render json: { state: 'success', msg: 'Login Success', user: { id: user.id, username: user.username, email: user.email } }, status: 200
      else
        flash[:danger] = '認証に失敗しました'
        render json: { state: 'failure', msg: 'Error' }, status: 403
      end
    else
      user = User.find_by('LOWER(email) = ?', session_params[:email].downcase) if session_params[:email].present?

      if Authenticator.new(user).authenticate(session_params[:password])
        if user.activated?
          log_in user
          render json: { state: 'success', msg: 'Login Success', user: { id: user.id, username: user.username, email: user.email } }, status: 200
        else
          render json: { state: 'failure', msg: 'Error' }, status: 403
        end
      end
    end
  end

  def guest_login
    user = User.find_by(email: 'guest@example.com')
    log_in user
    render json: { state: 'success', msg: 'Login Success', user: { id: user.id, username: user.username, email: user.email } }, status: 200
  end

  def destroy
    log_out
    render json: { state: 'success', msg: 'Log out' }, status: 200
  end

  private def session_params
    params.require(:session).permit(:email, :password)
  end
end
