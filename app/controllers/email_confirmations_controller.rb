class EmailConfirmationsController < ApplicationController
  skip_before_action :logged_in_user

  def edit
    user = User.find_by(email: params[:email])
    if user && user.authenticated?(:confirmation, params[:id])
      user.update_new_email
      log_in user unless logged_in?
      flash[:success] = 'メールアドレスが更新されました'
      redirect_to user
    else
      flash[:danger] = 'リンクが有効ではありません'
      if logged_in?
        redirect_to index_path(@today)
      else
        redirect_to login_path
      end
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
end
