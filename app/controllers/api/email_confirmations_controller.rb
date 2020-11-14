class Api::EmailConfirmationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_expiration, only: [:edit]

  def edit
    user = User.find_by(email: params[:email])
    if user && user.authenticated?(:confirmation, params[:id])
      user.update_new_email
      puts 'メールアドレスが更新されました'
      log_out
    else
      puts 'リンクが有効ではありません'
    end

    if user && logged_in?
      redirect_to "/user/#{user.id}/edit"
    else
      redirect_to root_path
    end
  end

  def destroy
    user = User.find(params[:id])
    puts 'メールアドレス変更をキャンセルしました' if user && user.update(confirmation_digest: nil, unconfirmed_email: nil)
  end

  private

  def check_expiration
    user = User.find_by(email: params[:email])
    if user && user.expired?(:confirmation)
      user.update(confirmation_digest: nil, unconfirmed_email: nil)
      puts 'メールアドレス認証リンクの期限が切れています'

      if user && logged_in?
        redirect_to "/user/#{user.id}/edit"
      else
        redirect_to root_path
      end
    end
  end
end
