require 'rails_helper'

RSpec.describe 'Passwords', type: :request do
  describe "passwordの" do
    let(:user) { create(:user) }
    let(:password_params) { { change_password_form: { password: "newpassword", password_confirmation: "newpassword"}} }

    before do
      sign_in_as(user)
    end

    it '編集画面が表示される' do
      get "/passwords/#{user.id}/edit"

      expect(response.status).to eq(200)
    end

    it '更新に成功する' do
      put "/api/users/#{user.id}/password", params: password_params

      expect(response.body).to include "パスワードが更新されました"
    end
  end
end
