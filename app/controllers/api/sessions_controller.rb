class Api::SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    auth = request.env['omniauth.auth']
    if auth.present?
      user = User.find_or_create_from_oauth(auth)
      if user.present?
        log_in user
        render json: user
      else
        flash[:danger] = '認証に失敗しました'
        render json: :failed
      end
    else
      user = User.find_by('LOWER(email) = ?', session_params[:email].downcase) if session_params[:email].present?

      if Authenticator.new(user).authenticate(session_params[:password])
        if user.activated?
          log_in user
          session_params[:remember_me?] ? remember(user) : forget(user)
          render json: :ok
        else
          render json: :failed
        end
      end
    end
  end

  def guest_login
    user = User.find_by!(email: 'guest@example.com')
    if log_in(user)
      render json: user
    else
      render json: :not_ok
    end
  end

  def destroy
    log_out if logged_in?
    render json: :ok
  end

  private def session_params
    params.require(:login_form).permit(:email, :password, :remember_me)
  end
end
