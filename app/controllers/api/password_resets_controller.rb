class Api::PasswordResetsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    password_reset_form = PasswordResetForm.new(password_reset_params)

    user = User.find_by(email: password_reset_form.email)
    if user && !user.activated?
      puts "アカウントが未認証です。送信されたメールをご確認ください。"
    end

    if user&.create_reset_digest
      user.send_password_reset_email
      puts 'パスワード再設定用のメールが送信されました'
      head :no_content
    else
      errors = { email: 'メールアドレスが見つかりません' }
      if password_reset_form.email.empty?
        errors[:email] =  'メールアドレスが未入力です'
      end
      render json: { errors: errors }, status: :unprocessable_entity
    end
  end

  def update
    user = User.find_by(email: params[:email])

    # パスワードリセット用リンクの期限が切れている場合
    if user&.expired?(:reset)
      user.update(reset_digest: nil)
      puts "パスワード再設定の期限が切れています"
      render json: { errors: { base: "パスワード再設定の期限が切れています" } }, status: :unprocessable_entity
      return
    # パスワードリセット用リンクが有効でない場合
    elsif user && !user.authenticated?(:reset, params[:id])
      puts "リンクが有効ではありません"
      render json: { errors: { base: "リンクが有効ではありません" } }, status: :unprocessable_entity
      return
    end

    password_param = user_params[:password]
    password_confirmation_param = user_params[:password]

    # エラーを初期化
    errors = {}
    # パスワードが未入力の場合
    if password_param.nil? || password_param.empty?
      errors[:password] = '新しいパスワードが未入力です'
    end
    # パスワード(確認用)が未入力の場合
    if password_confirmation_param.nil? || password_confirmation_param.empty?
      errors[:password_confirmation] = '新しいパスワード(確認用)が未入力です'
    end
    # エラーがある場合には表示
    if !errors.empty?
      render json: { errors: errors }, status: :unprocessable_entity
      return
    end

    # ユーザーのパスワードを更新
    if user&.update(user_params)
      log_in user
      user.update(reset_digest: nil)
      head :no_content
      puts 'パスワードがリセットされました。'
    else # パスワードを更新できなかった場合
      errors = user.errors.keys.map { |key| [key, user.errors.full_messages_for(key)[0]] }.to_h
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
end
