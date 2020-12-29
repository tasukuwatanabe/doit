module Api
  module V1
    class EmailConfirmationsController < ApplicationController
      before_action :set_user, only: :edit
      before_action :forbid_multiple_confirmation, only: :edit
      before_action :forbid_expired_confirmation_token, only: :edit

      def edit
        query = false

        if @user.authenticated?(:confirmation, params[:id])
          @user.update_new_email
          log_out
          query = true
        end

        redirect_to CLIENT_HOST + "/redirect?email_confirmed=#{query}"
      end

      def destroy
        user = User.find(params[:id])
        user.update!(confirmation_digest: nil, unconfirmed_email: nil)
        render json: { user: user, message: "メールアドレスの更新がキャンセルされました" }, status: 200
      end

      private

      def set_user
        @user = User.find_by(email: params[:email])
      end

      def forbid_multiple_confirmation
        # アドレス更新後はparams[:email]に旧アドレスが入るためUserが見つからなくなる
        unless @user
          redirect_to CLIENT_HOST + '/redirect?email_confirmed=false'
        end
      end

      def forbid_expired_confirmation_token
        if @user.expired?(:confirmation)
          @user.update(confirmation_digest: nil, unconfirmed_email: nil)
          redirect_to CLIENT_HOST + '/redirect?email_confirmed=expired'
        end
      end
    end
  end
end
