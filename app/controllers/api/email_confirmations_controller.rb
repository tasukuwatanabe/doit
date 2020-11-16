class Api::EmailConfirmationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_expiration, only: [:edit]

  def edit
    user = User.find_by(email: params[:email])
    if user && user.authenticated?(:confirmation, params[:id])
      user.update_new_email
      log_out
      # flash 'メールアドレスが更新されました'
      head :no_content
    else
      # flash 'リンクが有効ではありません'
      redirect_to root_path
    end
  end

  def destroy
    user = User.find(params[:id])
    if user && user.update(confirmation_digest: nil, unconfirmed_email: nil)
      head :no_content
    else
      errors = user.errors.keys.map { |key| [key, user.errors.full_messages_for(key)[0]] }.to_h
      render json: { errors: errors }, status: :unprocessable_entity
    end
  end

  private

  def check_expiration
    user = User.find_by(email: params[:email])
    if user && user.expired?(:confirmation)
      user.update(confirmation_digest: nil, unconfirmed_email: nil)
      puts 'メールアドレス認証リンクの期限が切れています'
    end
  end
end
