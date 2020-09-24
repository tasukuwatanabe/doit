class PasswordsController < ApplicationController
  def show
    redirect_to user_path(current_user)
  end

  def edit
    @change_password_form = ChangePasswordForm.new(object: current_user)
  end

  def update
    @change_password_form = ChangePasswordForm.new(user_params)
    @change_password_form.object = current_user
    if @change_password_form.save
      flash[:success] = 'パスワードを変更しました。'
      redirect_to current_user
    else
      render action: 'edit'
    end
  end

  private def user_params
    params.require(:change_password_form).permit(:current_password, :new_password, :new_password_confirmation)
  end
end
