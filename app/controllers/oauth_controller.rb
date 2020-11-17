class OauthController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    auth = request.env['omniauth.auth']
    user = User.find_or_create_from_oauth(auth)
    if user&.activated?
      log_in user
      redirect_to root_path
    else
      render json: { message: "ログインできませんでした" }, status: :unprocessable_entity
    end
  end

  def destroy
    provider = params[:provider].downcase!
    current_user.cancel_oauth(provider)
    render json: { message: "#{provider}とのSNS連携を解除しました" }
  end
end
