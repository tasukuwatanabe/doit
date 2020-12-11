class OauthController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    auth = request.env['omniauth.auth']
    user = User.find_or_create_from_oauth(auth)
    if user&.activated?
      log_in user

      if auth[:provider] == 'twitter'
        provider = 'Twitter'
      elsif auth[:provider] == 'facebook'
        provider = 'Facebook'
      elsif auth[:provider] == 'google_oauth2'
        provider = 'Google'
      end

      query_result = '?oauth=success'
      query_provider = "&provider=#{provider}"

      host = Rails.env.production? ? "https://doit-app.com" : "http://localhost:8080"
      redirect_to host + '/redirect' + query_result + query_provider
    else
      render json: { message: "ログインできませんでした" }, status: :unprocessable_entity
    end
  end

  def destroy
    provider = params[:provider]
    current_user.cancel_oauth(provider)
    render json: { message: "#{provider}とのSNS連携を解除しました" }
  end
end
