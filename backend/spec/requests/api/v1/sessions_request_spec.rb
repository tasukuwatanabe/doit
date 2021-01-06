require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe 'Session' do
    let(:user) { create(:user) }

    context 'ログイン' do
      let(:session_params) {
        {
          session: {
            email: email,
            password: password
          }
        }
      }

      context 'メールアドレスとパスワードの組み合わせ正しい' do
        let(:email) { user.email }
        let(:password) { user.password }

        it 'ログインに成功' do
          post '/api/v1/login', params: session_params

          expect(response.status).to eq(200)
        end
      end

      context 'メールアドレスとパスワードの組み合わせが間違っている' do
        let(:email) { user.email }
        let(:password) { "wrong_password" }

        it 'ログインに失敗' do
          post '/api/v1/login', params: session_params

          expect(response.status).to eq(422)
        end
      end

      context 'ゲストユーザーでのログイン' do
        let(:user) { create(:user, email: 'guest@example.com') }
        let(:email) { user.email }
        let(:password) { nil }

        it 'ログインに成功' do
          post '/api/v1/guest', params: session_params

          expect(response.status).to eq(200)
        end
      end
    end

    context 'ログアウト' do
      it '成功' do
        sign_in_as(user)

        delete '/api/v1/logout'

        expect(response.status).to eq(200)
      end
    end
  end
end