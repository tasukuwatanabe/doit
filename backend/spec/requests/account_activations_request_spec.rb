require 'rails_helper'

RSpec.describe "AccountActivations", type: :request do
  describe "アカウント認証が" do
    let(:user) { create(:user,  activated: false,
                                activation_token: User.new_token) }
    it "成功する" do
      get "/api/v1/account_activations/#{user.activation_token}/edit?email=#{user.email}"

      expect(response).to have_http_status(302)

      redirect_params = Rack::Utils.parse_query(URI.parse(response.location).query)
      expect(redirect_params).to eq("account_activation" => "activated")
    end
  end
end
