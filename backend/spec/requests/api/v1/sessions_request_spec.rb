require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe 'ユーザーの' do
    let(:user) { create(:user) }

    it 'ログインに成功すること' do
      post '/api/v1/login', params: { session: { email: user.email, password: user.password } }

      expect(response.status).to eq(200)
    end

    it 'ログインに失敗すること' do
      post '/api/v1/login', params: { session: { email: user.email, password: '' } }

      expect(response.status).to eq(422)
    end

    it 'ログアウトに成功すること' do
      sign_in_as(user)

      delete '/api/v1/logout'

      expect(response.status).to eq(200)
    end
  end
end
