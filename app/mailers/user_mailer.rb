class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user
    mail to: user.email, subject: 'アカウントの有効化'
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'パスワード再設定'
  end

  def email_confirmation(user)
    @user = user
    mail to: user.unconfirmed_email, subject: 'メールアドレスの確認'
  end
end
