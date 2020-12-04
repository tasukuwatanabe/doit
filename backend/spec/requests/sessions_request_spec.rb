require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe 'ユーザーの' do
    let(:user) { create(:user) }

    it 'ログインに成功すること' do
      post '/api/v1/login', params: { session: { email: user.email, password: user.password } }

      expect(response.status).to eq(200)
      expect(response.body).to include 'ログインしました'
    end

    it 'ログインに失敗すること' do
      post '/api/v1/login', params: { session: { email: user.email, password: '' } }

      expect(response.body).to include 'パスワードが未入力です'
    end

    it 'ログアウトに成功すること' do
      sign_in_as(user)

      delete '/api/logout'

      expect(response.body).to include 'ログアウトしました'
    end
  end
end
