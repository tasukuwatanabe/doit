require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe 'ユーザーの' do
    let(:user) { create(:user) }

    it 'ログイン画面が表示される' do
      get '/login'

      expect(response.status).to eq(200)
    end

    it 'ログインに成功すること' do
      post '/api/login', params: { session: { email: user.email, password: user.password } }

      expect(response.status).to eq(200)
      expect(response.body).to include 'ログインしました'
    end

    it 'ログインに失敗すること' do
      post '/api/login', params: { session: { email: user.email, password: '' } }

      expect(response.body).to include 'パスワードが未入力です'
    end

    it 'ログアウトに成功すること' do
      sign_in_as(user)

      delete '/api/logout'

      expect(response.body).to include 'ログアウトしました'
    end
  end
end
