require 'rails_helper'

RSpec.describe "AccountActivations", type: :request do
  describe "アカウント認証が" do
    let(:user) { create(:user, activated: false) }
    it "成功する" do
      get "/api/account_activations/#{user.email}"

      expect(response).to have_http_status(200)
    end
  end
end
