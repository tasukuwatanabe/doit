class OauthController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    auth = request.env['omniauth.auth']
    user = User.find_or_create_from_oauth(auth)
    if user&.activated?
      log_in user
      redirect_to root_path
    else
      render status: 403
    end
  end

  def cancel_oauth
    uid_type = params[:uid_type]
    current_user.cancel_oauth(uid_type)
    render status: 200
  end
end
