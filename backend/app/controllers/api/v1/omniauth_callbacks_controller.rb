module Api
  module V1
    class OmniauthCallbacksController < ApplicationController
      def create
        auth = request.env['omniauth.auth']
        user = User.find_or_create_from_oauth(auth)
        if user&.activated?
          log_in user

          provider =  if auth[:provider] == 'twitter'
                        'Twitter'
                      elsif auth[:provider] == 'facebook'
                        'Facebook'
                      elsif auth[:provider] == 'google_oauth2'
                        'Google'
                      end

          query_result = '?oauth=success'
          query_provider = "&provider=#{provider}"

          # redirect_to host + '/todos'
          redirect_to host + '/redirect' + query_result + query_provider
        else
          render json: { message: "ログインできませんでした" }, status: :unprocessable_entity
        end
      end

      def destroy
        provider = params[:provider]
        current_user.cancel_oauth(provider)
        render json: { message: "#{provider}との連携を解除しました" }, status: 200
      end
    end
  end
end
