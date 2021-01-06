require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe 'User' do
    let(:user) { create(:user) }

    it '新規登録が成功する' do
      user_params = {
        user: {
          username: 'ユーザー' ,
          email: 'signup@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }

      post '/api/v1/users', params: user_params

      expect(response.status).to eq(200)
      expect(response.body).to include "アカウント認証用のメールが送信されました"
    end

    it '削除が成功する' do
      sign_in_as(user)

      delete "/api/v1/users/#{user.id}"

      expect(response.status).to eq(200)
      expect(response.body).to include "ユーザーが削除されました"
    end

    it '情報を取得できる' do
      sign_in_as(user)

      get "/api/v1/users/current"

      expect(response.status).to eq(200)
    end

    it '情報を更新できる' do
      sign_in_as(user)

      user_params = {
        user: {
          username: "更新後のユーザー名",
          email: user.email
        }
      }

      put "/api/v1/users/#{user.id}", params: user_params

      expect(response.status).to eq(200)
      expect(response.body).to include "ユーザー情報が更新されました"
    end
  end
end
