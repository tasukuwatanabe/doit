module Api
  module V1
    class PasswordResetsController < ApplicationController
      before_action :forbid_guest_email, only: :create
      before_action :set_user, only: :update
      before_action :forbid_expired_reset_token, only: :update
      before_action :authenticate_user, only: :update

      def create
        user = User.find_by(email: password_reset_params[:email])
        if user
          user.create_reset_digest
          user.send_password_reset_email
          render json: { message: "パスワード再設定用のメールが送信されました"}, status: 200
        else
          errors = { email: 'メールアドレスが見つかりません' }
          render json: { errors: errors }, status: :unprocessable_entity
        end
      end

      def update
        change_password_form = ChangePasswordForm.new(@user, user_params)
        if change_password_form.save
          log_in @user
          render json: { user: @user, message: "パスワードがリセットされました" }, status: 200
        else
          render json: { errors: format_errors(change_password_form) }, status: :unprocessable_entity
        end
      end

      private

      def password_reset_params
        params.require(:password_reset_form).permit(:email)
      end

      def user_params
        params.require(:user).permit(:password, :password_confirmation)
      end

      def forbid_guest_email
        if password_reset_params[:email] == 'guest@example.com'
          render json: { errors: { email: "このアカウントはパスワードリセットできません。"} }, status: :unprocessable_entity
        end
      end

      def set_user
        @user = User.find_by(email: params[:email])
      end

      def forbid_expired_reset_token
        if @user&.expired?(:reset)
          render json: { message: "リンクの有効期限が過ぎています"}, status: :unprocessable_entity
          return
        end
      end

      def authenticate_user
        unless @user&.authenticated?(:reset, params[:id])
          render json: { message: "リンクが有効ではありません"}, status: :unprocessable_entity
          return
        end
      end
    end
  end
end