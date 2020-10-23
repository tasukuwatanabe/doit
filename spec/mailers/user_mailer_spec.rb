require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let!(:user) { create(:user) }

  describe 'account_activation' do
    let(:mail) { UserMailer.account_activation(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('アカウントの有効化')
      expect(mail.to).to eq(['testemail@example.com'])
      expect(mail.from).to eq(['noreply@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Hi')
    end
  end

  describe 'email_confirmation' do
    let(:mail) { UserMailer.email_confirmation(user) }
    let(:mail_body) { mail.body.encoded.split(/\r\n/).map { |i| Base64.decode64(i) }.join }

    it 'renders the headers' do
      user.confirmation_token = User.new_token
      mail = UserMailer.email_confirmation(user)
      expect(mail.subject).to eq('メールアドレスの確認')
      expect(mail.from).to eq(['noreply@example.com'])
    end

    it 'renders the body' do
      user.confirmation_token = User.new_token
      mail = UserMailer.email_confirmation(user)
      expect(mail_body).to match CGI.escape(user.email)
    end
  end
end
