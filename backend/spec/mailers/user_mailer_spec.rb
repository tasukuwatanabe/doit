require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user, email: "useremail@example.com", unconfirmed_email: 'unconfirmed@example.com') }
  let(:mail_body) { mail.body.encoded.split(/\r\n/).map { |i| Base64.decode64(i) }.join }

  describe 'AccountActivation' do
    let(:mail) { UserMailer.account_activation(user) }

    it 'mail headers' do
      expect(mail.subject).to eq('アカウントの有効化')
      expect(mail.from).to eq(['noreply@doit-app.com'])
      expect(mail.to).to eq(['useremail@example.com'])
    end

    it 'mail body' do
      expect(mail_body).to match CGI.escape(user.email)
    end
  end

  describe 'EmailConfirmation' do
    let(:mail) { UserMailer.email_confirmation(user) }

    it 'mail headers' do
      expect(mail.subject).to eq('メールアドレスの確認')
      expect(mail.from).to eq(['noreply@doit-app.com'])
      expect(mail.to).to eq(['unconfirmed@example.com'])
    end

    it 'mail body' do
      expect(mail_body).to match CGI.escape(user.email)
    end
  end

  describe 'PasswordResets' do
    let(:mail) { UserMailer.password_reset(user) }

    it 'mail headers' do
      expect(mail.subject).to eq('パスワードリセット')
      expect(mail.from).to eq(['noreply@doit-app.com'])
      expect(mail.to).to eq(['useremail@example.com'])
    end

    it 'mail body' do
      expect(mail_body).to match(user.email)
    end
  end
end
