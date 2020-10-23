class EmailConfirmationsController < ApplicationController
  skip_before_action :logged_in_user
  before_action :check_expiration, only: [:edit]

  def edit
    user = User.find_by(email: params[:email])
    if user && user.authenticated?(:confirmation, params[:id])
      user.update_new_email
      flash[:success] = 'メールアドレスが更新されました'
      redirect_to logged_in? ? user : login_path
    else
      flash[:danger] = 'リンクが有効ではありません'
      redirect_to logged_in? ? root_path : login_path
    end
  end

  def destroy
    user = User.find(params[:id])
    user.confirmation_digest = nil
    user.unconfirmed_email = nil
    if user.save
      flash[:success] = 'メールアドレス変更をキャンセルしました'
      redirect_to user
    end
  end

  private

  def check_expiration
    user = User.find_by(email: params[:email])
    if user && user.expired?(:confirmation)
      user.unconfirmed_email = nil
      user.confirmation_digest = nil
      user.save
      flash[:danger] = 'メールアドレス認証リンクの期限が切れています'
      redirect_to logged_in? ? user : login_path
    end
  end
end
