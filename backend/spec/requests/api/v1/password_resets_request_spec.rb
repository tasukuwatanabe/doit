require 'rails_helper'

RSpec.describe 'PasswordResets', type: :request do
  let(:user) { create(:user) }

  describe "パスワードリセット用のメール発行" do

    context '存在するメールアドレスを入力' do
      it 'メール発行に成功する' do
        correct_email = { email: user.email }

        post "/api/v1/password_resets", params: { password_reset_form: correct_email }

        expect(response.status).to eq(200)
        expect(response.body).to include "パスワード再設定用のメールが送信されました"
      end
    end

    context '存在しないメールアドレスを入力' do
      it 'メール発行に失敗する' do
        new_email = { email: "newemail@example.com" }

        post "/api/v1/password_resets", params: { password_reset_form: new_email }

        expect(response.status).to eq(422)
      end
    end

    context 'ゲストユーザー用のメールアドレスを入力' do
      it 'メール発行に失敗する' do
        guest_email = { email: "guest@example.com" }

        post "/api/v1/password_resets", params: { password_reset_form:  guest_email }

        expect(response.status).to eq(422)
      end
    end
  end

  describe "新しいパスワードを入力" do

    before do
      user.update(
        reset_digest: User.digest(user.reset_token),
        reset_sent_at: Time.zone.now
      )
    end

    context '新しいパスワードの組み合わせが一致' do
      it 'パスワード更新に成功する' do
        user_params = {
          user: {
            password: "foobar",
            password_confirmation: "foobar"
          },
          email: user.email
        }

        put "/api/v1/password_resets/#{user.reset_token}", params: user_params

        expect(response.status).to eq(200)
        expect(response.body).to include "パスワードがリセットされました"
      end
    end

    context '新しいパスワードの組み合わせが不一致' do
      it 'パスワード更新に失敗する' do
        user_params = {
          user: {
            password: "foobar",
            password_confirmation: "hogehoge",
          },
          email: user.email
        }

        put "/api/v1/password_resets/#{user.reset_token}", params: user_params

        expect(response.status).to eq(422)
      end
    end

    context '新しいパスワードの組み合わせが6文字より少ない' do
      it 'パスワード更新に失敗する' do
        user_params = {
          user: {
            password: "hoge",
            password_confirmation: "hoge",
          },
          email: user.email
        }

        put "/api/v1/password_resets/#{user.reset_token}", params: user_params

        expect(response.status).to eq(422)
      end
    end

    context 'メール発行から2時間以上が経過' do
      it 'パスワード更新に失敗する' do
        user.update(
          reset_sent_at: 120.minutes.ago
        )

        user_params = {
          user: {
            password: "foobar",
            password_confirmation: "foobar",
          },
          email: user.email
        }

        put "/api/v1/password_resets/#{user.reset_token}", params: user_params

        expect(response.status).to eq(422)
        expect(response.body).to include "リンクの有効期限が過ぎています"
      end
    end

    context 'reset_tokenとreset_digestの認証に失敗' do
      it 'パスワード更新に失敗する' do
        user.update(
          reset_digest: User.digest(User.new_token)
        )

        user_params = {
          user: {
            password: "foobar",
            password_confirmation: "foobar",
          },
          email: user.email
        }

        put "/api/v1/password_resets/#{user.reset_token}", params: user_params

        expect(response.status).to eq(422)
        expect(response.body).to include "リンクが有効ではありません"
      end
    end
  end
end
