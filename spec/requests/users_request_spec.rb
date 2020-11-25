require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe 'ユーザーの' do
    let(:user) { create(:user) }

    it '新規登録画面が表示される' do
      get '/signup'

      expect(response.status).to eq(200)
    end

    it '新規登録が成功する' do
      post '/api/users', params: { user: { username: 'ユーザー' , email: 'signup@exaample.com', password: 'password', password_confirmation: 'password' } }
      expect(response.body).to include "アカウント認証用のメールが送信されました"
    end

    it '削除が成功する' do
      sign_in_as(user)

      delete "/api/users/#{user.id}"

      expect(response.body).to include "ユーザーが削除されました"
    end

    it '編集画面が表示される' do
      sign_in_as(user)

      get "/users/#{user.id}/edit"

      expect(response.status).to eq(200)
    end

    it '情報を取得できる' do
      sign_in_as(user)

      get "/api/current_user"

      expect(response.status).to eq(200)
    end

    it '情報を更新できる' do
      sign_in_as(user)

      put "/api/users/#{user.id}", params: { user: { username: "ユーザー更新" }}

      expect(response.body).to include "ユーザー情報が更新されました"
    end
  end
end
