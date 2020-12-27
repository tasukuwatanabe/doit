require 'rails_helper'

RSpec.describe "EmailConfirmations", type: :request do
  describe "EmailConfirmation" do
    let!(:user) { create(:user, email: "old.email@example.com",
                                unconfirmed_email: "new.email@example.com") }

    before do
      @email_confirmations_path = "/api/v1/email_confirmations/#{user.confirmation_token}/edit?email=#{user.email}"
    end

    context "認証メールの発行から2時間以内" do
      it "メールアドレス認証に成功する" do
        get @email_confirmations_path

        expect(response.status).to be(302)
        expect(response).to redirect_to %r(\Ahttp://www.example.com/redirect)

        redirect_params = Rack::Utils.parse_query(URI.parse(response.location).query)
        expect(redirect_params).to eq("email_confirmed" => "true")
        expect(user.reload.email).to eq("new.email@example.com")
        expect(user.reload.unconfirmed_email).to be_nil
      end
    end

    context "有効期限切れの場合" do
      it "メールアドレス認証に失敗する" do
        user.update(confirmation_sent_at: 121.minutes.ago)

        get @email_confirmations_path

        expect(response.status).to be(302)
        expect(response).to redirect_to %r(\Ahttp://www.example.com/redirect)

        redirect_params = Rack::Utils.parse_query(URI.parse(response.location).query)
        expect(redirect_params).to eq("email_confirmed" => "expired")
        expect(user.reload.confirmation_digest).to be_nil
        expect(user.reload.unconfirmed_email).to be_nil
      end
    end

    context "confirmation_tokenとconfirmation_digestの認証に失敗" do
      it "メールアドレス認証に失敗する" do
        user.update(confirmation_digest: User.digest(User.new_token))
        get @email_confirmations_path

        expect(response.status).to be(302)
        expect(response).to redirect_to %r(\Ahttp://www.example.com/redirect)
        
        redirect_params = Rack::Utils.parse_query(URI.parse(response.location).query)
        expect(redirect_params).to eq("email_confirmed" => "false")
      end
    end
  end

  describe "メールアドレス認証のキャンセル" do
    let(:user) { create(:user) }

    it "成功する" do
      delete "/api/v1/email_confirmations/#{user.id}"

      expect(response.status).to be(200)
      expect(user.reload.unconfirmed_email).to be_nil
    end
  end
end
