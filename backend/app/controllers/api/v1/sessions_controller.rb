module Api
  module V1
    class SessionsController < ApplicationController

      def create
        user = User.find_by(email: session_params[:email])
        if Authenticator.new(user).authenticate(session_params[:password])
          log_in user
          render json: { user: user, message: "#{user.username}でログインしました"}, status: 200
        else
          render json: { message: "メールアドレスまたはパスワードが違います" }, status: :unprocessable_entity
        end
      end

      def destroy
        log_out
        head :ok
      end

      def guest
        user = User.find_by(email: "guest@example.com")
        log_in user
        render json: { user: user, message: "ゲストユーザーでログインしました"}, status: 200
      end

      private

      def session_params
        params.require(:session).permit(:email, :password)
      end
    end
  end
end
