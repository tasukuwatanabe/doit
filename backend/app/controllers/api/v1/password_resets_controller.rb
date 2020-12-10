module Api
  module V1
    class PasswordResetsController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :check_empty, only: :create
      before_action :get_user, only: :update
      before_action :check_expiration, only: :update
      before_action :valid_user, only: :update
      before_action :check_email, only: :create

      def create
        user = User.find_by(email: password_reset_params[:email])
        user.create_reset_digest if user

        if user&.send_password_reset_email
          render json: { message: "パスワード再設定用のメールが送信されました"}
        else
          errors = { email: 'メールアドレスが見つかりません' }
          render json: { errors: errors }, status: :unprocessable_entity
        end
      end

      def update
        change_password_form = ChangePasswordForm.new(user_params)
        change_password_form.object = @user
        if change_password_form.save
          log_in @user
          render json: { message: "パスワードがリセットされました。" }
        else
          errors = change_password_form.errors.keys.map { |key| [key, change_password_form.errors.full_messages_for(key)[0]] }.to_h
          render json: { errors: errors }, status: :unprocessable_entity
        end
      end

      private

      def password_reset_params
        params.fetch(:password_reset_form, {}).permit(:email)
      end

      def user_params
        params.fetch(:user, {}).permit(:password, :password_confirmation)
      end

      def check_empty
        if password_reset_params[:email].empty?
          errors = { email:  'メールアドレスが未入力です' }
          render json: { errors: errors }, status: :unprocessable_entity
          return
        end
      end

      def check_email
        if password_reset_params[:email] == 'guest@example.com'
          render json: { errors: { email: "このアカウントはパスワードリセットできません。"} }, status: :unprocessable_entity
        end
      end

      def get_user
        @user = User.find_by(email: params[:email])
      end

      def check_expiration
        if @user && @user.expired?(:reset)
          render json: { message: "リンクの有効期限が過ぎています"}, status: :unprocessable_entity
          return
        end
      end

      def valid_user
        unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
          render json: { message: "リンクが有効ではありません"}, status: :unprocessable_entity
          return
        end
      end
    end
  end
end