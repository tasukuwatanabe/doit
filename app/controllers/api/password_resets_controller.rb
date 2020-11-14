class Api::PasswordResetsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    form = PasswordResetForm.new(password_reset_params)
    user = User.find_by(email: form.email)
    if user
      user.create_reset_digest
      user.send_password_reset_email
      puts 'パスワード再設定用のメールが送信されました'
    else
      puts 'メールアドレスが見つかりません'
      render status: 443
    end
  end

  def update
    user = User.find_by(email: params[:email])

    if user&.expired?(:reset)
      user.update(reset_digest: nil)
      puts 'パスワード再設定の期限が切れています'
      render status: 443
    elsif user&.authenticated?(:reset, params[:id])
      puts 'リンクが有効ではありません'
      render status: 443
    elsif user && !user.activated?
      puts 'アカウントが未認証です'
      render status: 443
    end

    if user&.update(user_params)
      log_in user
      user.update(reset_digest: nil)
      puts 'パスワードがリセットされました。'
    else
      puts '入力内容に不備があります'
      render status: 443
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
