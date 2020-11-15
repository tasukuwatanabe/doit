class Api::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def current_user
    if user_id = cookies.signed[:user_id]
      current_user = User.find(user_id)
      current_user = {
        id: current_user.id,
        username: current_user.username,
        email: current_user.email,
        user_image: current_user.user_image.url,
        facebook_uid: current_user.facebook_uid,
        twitter_uid: current_user.twitter_uid,
        google_uid: current_user.google_uid,
        auto_generated_password: current_user.auto_generated_password,
        unconfirmed_email: current_user.unconfirmed_email,
        remove_user_image: current_user.remove_user_image
      }
    else
      current_user = nil
    end

    render json: current_user
  end

  def create
    user = User.new(user_params)
    if user.save
      user.send_activation_email
    else
      errors = user.errors.keys.map { |key| [key, user.errors.full_messages_for(key)] }.to_h
      render json: { errors: errors }, status: :unprocessable_entity
    end
  end

  def update
    user = User.find(params[:id])

    # プロフィール画像を初期化
    user.update(sns_profile_image: nil) if user_params[:remove_user_image] == '1'

    # パラメータ[:email]を取得
    new_email = user_params[:email]
    # .gsub(/　/, '')

    # メールアドレス使用状況をチェック
    if new_email && user && User.email_used?(user, new_email)
      email_error = { unconfirmed_email: ['このメールアドレスはすでに使われています。'] }
    elsif new_email == '' # メールアドレスが空の場合
      email_error = { unconfirmed_email: ['メールアドレスが入力されていません。'] }
    end

    # メールアドレスに変更がある場合
    if new_email != user.email

      # new_emailがバリデーションを通る場合
      if user.update(unconfirmed_email: new_email, confirmation_token: User.new_token)
        user.update_attribute(:confirmation_digest, User.digest(user.confirmation_token))
        user.update_attribute(:confirmation_sent_at, Time.zone.now)
        # メールアドレス確認用のメールを送信
        UserMailer.email_confirmation(user).deliver_now
      else # バリデーションを取得
        errors = user.errors.keys.map { |key| [key, user.errors.full_messages_for(key)] }.to_h unless email_error
      end
    end

    # email、unconfirmed_email以外を更新
    if user&.update(user_params.except(:email, :unconfirmed_email))
      if email_error
        render json: { errors: email_error }, status: :unprocessable_entity
      else
        head :no_content
      end
    else # バリデーションエラーを取得
      errors = user.errors.keys.map { |key| [key, user.errors.full_messages_for(key)] }.to_h
      errors.merge!(email_error) if email_error
      render json: { errors: errors }, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    destroy_cookie
    head :no_content
  end

  private

  def user_params
    params.fetch(:user, {}).permit(:id, :username, :password, :email, :password_confirmation, :user_image, :remove_user_image, :facebook_uid, :twitter_uid, :google_uid, :auto_generated_password, :unconfirmed_email)
  end
end
