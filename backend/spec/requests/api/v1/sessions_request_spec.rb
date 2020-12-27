require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe 'Session' do
    let(:user) { create(:user) }

    it 'ログインに成功する' do
      post '/api/v1/login', params: { session: { email: user.email, password: user.password } }

      expect(response.status).to eq(200)
    end

    it 'ログインに失敗する' do
      post '/api/v1/login', params: { session: { email: user.email, password: '' } }

      expect(response.status).to eq(422)
    end

    it 'ログアウトに成功する' do
      sign_in_as(user)

      delete '/api/v1/logout'

      expect(response.status).to eq(200)
    end
  end

  describe 'ゲストユーザーでの' do
    let(:user) { create(:user, email: "guest@example.com") }

    it 'ログインに成功する' do
      post '/api/v1/guest', params: { session: { email: user.email } }

      expect(response.status).to eq(200)
    end
  end
end
