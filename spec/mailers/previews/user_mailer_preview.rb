class UserMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  
  user = User.first
  
  def account_activation
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  def email_confirmation
    user.confirmation_token = User.new_token
    UserMailer.email_confirmation(user)
  end

  def password_reset
    user.reset_token = User.new_token
    UserMailer.password_reset
  end
end
