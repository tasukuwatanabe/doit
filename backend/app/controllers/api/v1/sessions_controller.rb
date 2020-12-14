module Api
  module V1
    class SessionsController < ApplicationController
      before_action :check_empty, only: :create

      def create
        # ゲストログインの場合
        if @email == "guest@example.com"
          if user = User.find_by(email: @email)
            log_in user
            render json: { user: user, message: "ゲストユーザーでログインしました" }, status: 200
          else
            render json: { message: "ログインに失敗しました"}, status: :unprocessable_entity
          end
        else
          user = User.find_by('LOWER(email) = ?', @email.downcase)
          if user && Authenticator.new(user).authenticate(@password)
            if user.activated? # アカウントの認証状況を確認
              log_in user
              render json: { user: user, message: "#{user.username}でログインしました" }, status: 200
            else # アカウントが未認証ならエラーを表示
              errors = { base: 'アカウントが未認証です' }
              render json: { errors: errors }, status: :unprocessable_entity
            end
          else # 入力情報が誤っていればエラーを表示
            errors = { base: 'メールアドレスもしくはパスワードが違います' }
            render json: { errors: errors }, status: :unprocessable_entity
          end
          return
        end
      end

      def destroy
        log_out
        render json: { message: "ログアウトしました"}
      end

      private 
      
      def session_params
        params.require(:session).permit(:email, :password)
      end

      def check_empty
        @email = session_params[:email]
        @password = session_params[:password]

        unless @email == "guest@example.com"
          # メールアドレス/パスワードが空ならエラー
          errors = {}
          if @email.nil? || @email.empty?
            errors[:email] = 'メールアドレスが未入力です。'
          end
          if @password.nil? || @password.empty?
            errors[:password] = 'パスワードが未入力です。'
          end

          # エラーがあれば表示
          if errors.any?
            render json: { errors: errors }, status: :unprocessable_entity
            return
          end
        end
      end
    end
  end
end
