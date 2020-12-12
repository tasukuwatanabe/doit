module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :check_email, only: [:create, :update]

      def current_user
        if user_id = cookies.signed[:user_id]
          current_user = User.find(user_id)
          current_user = {
            id: current_user.id,
            username: current_user.username,
            email: current_user.email,
            user_image: current_user.user_image,
            facebook_uid: current_user.facebook_uid,
            twitter_uid: current_user.twitter_uid,
            google_uid: current_user.google_uid,
            auto_generated_password: current_user.auto_generated_password,
            unconfirmed_email: current_user.unconfirmed_email
          }
        else
          current_user = nil
        end

        render json: current_user, status: 200
      end

      def create
        user = User.new(user_params)
        if user.save
          user.send_activation_email
          render json: { message: "アカウント認証用のメールが送信されました" }
        else
          errors = user.errors.keys.map { |key| [key, user.errors.full_messages_for(key)[0]] }.to_h
          render json: { errors: errors }, status: :unprocessable_entity
        end
      end

      def update
        user = User.find(params[:id])

        # プロフィール画像を初期化
        user.update(sns_profile_image: nil) if user_params[:remove_user_image] == '1'

        # パラメータ[:email]を取得
        new_email = user_params[:email]

        # メールアドレス使用状況をチェック
        if new_email && user && User.email_used?(user, new_email)
          email_error = { unconfirmed_email: 'このメールアドレスはすでに使われています。' }
        end

        # メールアドレスに変更がある場合
        if new_email != user.email

          # new_emailがバリデーションを通る場合
          if user.update(unconfirmed_email: new_email, confirmation_token: User.new_token)
            user.update_attribute(:confirmation_digest, User.digest(user.confirmation_token))
            user.update_attribute(:confirmation_sent_at, Time.zone.now)
            # メールアドレス確認用のメールを送信
            UserMailer.email_confirmation(user).deliver_later
          else # バリデーションを取得
            if email_error.present?
              errors = user.errors.keys.map { |key| [key, user.errors.full_messages_for(key)[0]] }.to_h
            end
          end
        end

        # email、unconfirmed_email以外を更新
        if user&.update(user_params.except(:email, :unconfirmed_email))
          if email_error
            render json: { errors: email_error }, status: :unprocessable_entity
          else
            render json: { user: user, message: "ユーザー情報が更新されました" }
          end
        else # バリデーションエラーを取得
          errors = user.errors.keys.map { |key| [key, user.errors.full_messages_for(key)[0]] }.to_h
          errors.merge!(email_error) if email_error
          render json: { errors: errors }, status: :unprocessable_entity
        end
      end

      def destroy
        user = User.find(params[:id])
        user.destroy
        destroy_cookie
        render json: { message: "ユーザーが削除されました" }
      end

      private

      def user_params
        params.require(:user).permit(:username, :password, :email, :password_confirmation, :user_image, :remove_user_image, :facebook_uid, :twitter_uid, :google_uid, :auto_generated_password, :unconfirmed_email)
      end

      def check_email
        if user_params[:email] == 'guest@example.com'
          render json: { errors: { email: "このメールアドレスは使用できません。"} }, status: :unprocessable_entity
        end
      end
    end
  end
end
