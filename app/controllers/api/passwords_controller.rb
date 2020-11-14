class Api::PasswordsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def edit
    @change_password_form = ChangePasswordForm.new(object: current_user)
  end

  def update
    @change_password_form = ChangePasswordForm.new(password_params)
    @change_password_form.object = current_user
    @change_password_form.object.auto_generated_password = nil
    if @change_password_form.save
      puts 'パスワードを更新しました。'
    else
      puts 'パスワードを更新できませんでした。'
    end
  end

  private def password_params
    params.fetch(:change_password_form, {}).permit(:id, :new_password, :new_password_confirmation)
  end
end
