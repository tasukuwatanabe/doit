class Api::PasswordResetsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_empty, only: :create
  before_action :get_user, only: :update
  before_action :check_expiration, only: :update
  before_action :valid_user, only: :update

  def create
    # password_reset_form = PasswordResetForm.new(password_reset_params)

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

    errors = {}

    # パスワードが未入力の場合
    if user_params[:password].empty?
      errors[:password] = '新しいパスワードが未入力です'
    end
    # パスワード(確認用)が未入力の場合
    if user_params[:password_confirmation].empty?
      errors[:password_confirmation] = '新しいパスワード(確認用)が未入力です'
    end
    # エラーがある場合には表示
    unless errors.empty?
      render json: { errors: errors }, status: :unprocessable_entity
      return
    end

    # ユーザーのパスワードを更新
    if @user.update_attributes(user_params)
      log_in @user
      render json: { message: "パスワードがリセットされました。" }
    else
      errors = @user.errors.keys.map { |key| [key, @user.errors.full_messages_for(key)[0]] }.to_h
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
