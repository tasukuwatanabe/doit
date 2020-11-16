class Api::PasswordsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def update
    change_password_form = ChangePasswordForm.new(password_params)
    change_password_form.object = current_user
    change_password_form.object.auto_generated_password = nil
    if change_password_form.save
      head :no_content
    else
      errors = change_password_form.errors.keys.map { |key| [key, change_password_form.errors.full_messages_for(key)[0]] }.to_h
      render json: { errors: errors }, status: :unprocessable_entity
    end
  end

  private def password_params
    params.fetch(:change_password_form, {}).permit(:id, :new_password, :new_password_confirmation)
  end
end
