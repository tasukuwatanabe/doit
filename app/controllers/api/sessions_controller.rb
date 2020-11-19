class Api::SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    email_param = session_params[:email]
    password_param = session_params[:password]

    # メールアドレスでユーザーを検索
    if email_param
      user = User.find_by('LOWER(email) = ?', email_param.downcase)
    end

    # メールアドレス/パスワードが空ならエラー
    errors = {}
    if email_param.nil? || email_param.empty?
      errors[:email] = 'メールアドレスが未入力です。'
    end
    if password_param.nil? || password_param.empty?
      errors[:password] = 'パスワードが未入力です。'
    end

    # エラーがあれば表示
    if errors.any?
      render json: { errors: errors }, status: :unprocessable_entity
      return
    end

    # ユーザー認証
    if user && Authenticator.new(user).authenticate(password_param)
      if user.activated? # アカウントの認証状況を確認
        log_in user
        render json: { message: "ログインしました" }
      else # アカウントが未認証ならエラーを表示
        errors = { base: 'アカウントが未認証です。送信されたメールをご確認ください。' }
        render json: { errors: errors }, status: :unprocessable_entity
      end
    else # 入力情報が誤っていればエラーを表示
      errors = { base: 'メールアドレスもしくはパスワードが間違えています。' }
      render json: { errors: errors }, status: :unprocessable_entity
    end
  end

  def guest_login
    user = User.find_by(email: 'guest@example.com')
    if user
      log_in user
      render json: { message: "ゲストユーザーでログインしました"}
    else
      render json: { message: "ゲストユーザーが見つかりません"}, status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    render json: { message: "ログアウトしました"}
  end

  private def session_params
    params.fetch(:session, {}).permit(:id, :email, :password)
  end
end
