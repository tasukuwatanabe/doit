module Api
  module V1
    class OmniauthCallbacksController < ApplicationController
      def create
        auth = request.env['omniauth.auth']
        service = OmniauthUserCreateService.new(auth)
        user = service.result
        if user&.activated?
          log_in user

          redirect_to CLIENT_HOST + '/redirect?oauth=success&provider=' + generate_query(auth[:provider])
        else
          render json: { message: "ログインできませんでした" }, status: :unprocessable_entity
        end
      end

      def destroy
        provider = params[:provider]
        current_user.cancel_oauth!(provider)
        message = generate_query(provider) + "との連携を解除しました"
        render json: { user: current_user, message: message }, status: 200
      end

      private

      def generate_query(provider)
        provider_names = {
          twitter: "Twitter",
          facebook: "Facebook",
          google_oauth2: "Google",
        }

        provider_names[provider.to_sym]
      end
    end
  end
end
