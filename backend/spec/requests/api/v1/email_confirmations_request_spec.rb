require 'rails_helper'

RSpec.describe "EmailConfirmations", type: :request do
  let(:token) { User.new_token }
  let(:digest) { User.digest(token) }

  describe "メールアドレス認証が" do
    let(:user) { create(:user,  unconfirmed_email: "unconfirmed@example.com",
                                confirmation_token: token,
                                confirmation_digest: digest,
                                confirmation_sent_at: 1.minutes.ago) }

    it "成功する" do
      get "/api/v1/email_confirmations/#{user.confirmation_token}/edit?email=#{user.email}"

      expect(response).to have_http_status(302)
      expect(response).to redirect_to %r(\Ahttp://www.example.com/redirect)
      
      redirect_params = Rack::Utils.parse_query(URI.parse(response.location).query)
      expect(redirect_params).to eq("email_confirmed" => "true")
    end
  end

  describe "有効期限切れの場合、認証が" do
    let(:user) { create(:user,  unconfirmed_email: "unconfirmed@example.com",
                                confirmation_token: token,
                                confirmation_digest: digest,
                                confirmation_sent_at: 1.days.ago) }

    it "失敗する" do

      get "/api/v1/email_confirmations/#{user.confirmation_token}/edit?email=#{user.email}"

      expect(response).to have_http_status(302)
      expect(response).to redirect_to %r(\Ahttp://www.example.com/redirect)
      
      redirect_params = Rack::Utils.parse_query(URI.parse(response.location).query)
      expect(redirect_params).to eq("email_confirmed" => "expired")
    end
  end

  describe "認証のキャンセルが" do
    let(:user) { create(:user, unconfirmed_email: "unconfirmed@example.com") }

    it "成功する" do
      delete "/api/v1/email_confirmations/#{user.id}"

      expect(response).to have_http_status(200)
    end
  end
end
