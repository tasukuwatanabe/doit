require 'rails_helper'

RSpec.describe "AccountActivations", type: :request do
  describe "AccountActivation" do
    let(:user) { create(:user,  activated: false) }

    before do
      @account_activations_path = "/api/v1/account_activations/#{user.activation_token}/edit?email=#{user.email}"
    end

    context '' do
      it "アカウント認証に成功する" do
        get @account_activations_path

        expect(response.status).to eq(302)

        redirect_params = Rack::Utils.parse_query(URI.parse(response.location).query)
        expect(redirect_params).to eq("account_activation" => "activated")
        expect(user.reload.activated).to be true
      end
    end

    context 'メールリンクを複数回クリックする' do
      it "URLにalreadyというクエリがついた状態でリダイレクト" do
        user.update(activated: true)

        get @account_activations_path

        expect(response.status).to eq(302)

        redirect_params = Rack::Utils.parse_query(URI.parse(response.location).query)
        expect(redirect_params).to eq("account_activation" => "already")
      end
    end

    context 'activation_tokenとactivation_digestが認証に失敗' do
      it "アカウント認証に失敗する" do
        user.update(activation_digest: User.digest(User.new_token))

        get @account_activations_path

        expect(response.status).to eq(302)

        redirect_params = Rack::Utils.parse_query(URI.parse(response.location).query)
        expect(redirect_params).to eq("account_activation" => "invalid")
        expect(user.reload.activated).to be false
      end
    end
  end
end
