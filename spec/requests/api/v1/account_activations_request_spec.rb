require 'rails_helper'

RSpec.describe "AccountActivations", type: :request do
  describe "AccountActivation" do
    let(:user) { create(:user,  activated: activated) }

    before do
      @account_activations_path = "/api/v1/account_activations/#{user.activation_token}/edit?email=#{user.email}"
    end

    context '通常のアカウント認証' do
      let(:activated) { false }

      it "アカウント認証に成功" do
        get @account_activations_path

        expect(response.status).to eq(302)

        redirect_params = Rack::Utils.parse_query(URI.parse(response.location).query)
        expect(redirect_params).to eq("account_activation" => "activated")
        expect(user.reload.activated).to be true
      end
    end

    context 'メールリンクを複数回クリック' do
      let(:activated) { true }

      it "actiavatedはtrueのまま" do
        get @account_activations_path

        expect(response.status).to eq(302)

        redirect_params = Rack::Utils.parse_query(URI.parse(response.location).query)
        expect(redirect_params).to eq("account_activation" => "already")
      end
    end

    context 'tokenとdigestの認証に失敗' do
      let(:activated) { false }

      it "アカウント認証に失敗" do
        user.update(activation_digest: User.digest(User.new_token))

        get @account_activations_path

        expect(response.status).to eq(302)

        redirect_params = Rack::Utils.parse_query(URI.parse(response.location).query)
        expect(redirect_params).to eq("account_activation" => "invalid")
      end
    end
  end
end
