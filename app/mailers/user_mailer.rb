class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user
    mail to: user.email, subject: 'DoIT | アカウントの有効化'
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'DoIT | パスワードリセット'
  end

  def email_confirmation(user)
    @user = user
    mail to: user.unconfirmed_email, subject: 'DoIT | メールアドレスの確認'
  end
end
