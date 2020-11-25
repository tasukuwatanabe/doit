require 'rails_helper'

RSpec.describe "EmailConfirmations", type: :request do
  describe "メールアドレス認証が" do
    let(:user) { create(:user) }
    it "成功する" do
      get "/api/email_confirmations/#{user.email}"

      expect(response).to have_http_status(200)
    end
  end

  describe "メールアドレス認証のキャンセルが" do
    let(:user) { create(:user, unconfirmed_email: "unconfirmed@example.com") }

    it "成功する" do
      delete "/api/email_confirmations/#{user.id}"

      expect(response).to have_http_status(200)
    end
  end
end
