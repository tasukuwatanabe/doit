require 'rails_helper'

RSpec.describe 'Passwords', type: :request do
  describe "Password" do
    let(:user) { create(:user) }
    let(:password_params) {
      {
        change_password_form: {
          password: password,
          password_confirmation: password_confirmation
        }
      }
    }

    before do
      sign_in_as(user)
      @password_path = "/api/v1/users/#{user.id}/password"
    end

    context '新しいパスワードの組み合わせが一致' do
      let(:password) { "new_password" }
      let(:password_confirmation) { "new_password" }

      it '更新に成功する' do
        put @password_path, params: password_params

        expect(response.status).to eq(200)
        expect(response.body).to include "パスワードが更新されました"
      end
    end

    context '新しいパスワードの組み合わせが不一致' do
      let(:password) { "a" * 10 }
      let(:password_confirmation) { "b" * 10 }

      it '更新に失敗する' do
        put @password_path, params: password_params

        expect(response.status).to eq(422)
      end
    end

    context '新しいパスワードの組み合わせが6文字より少ない' do
      let(:password) { "a" * 5 }
      let(:password_confirmation) { "b" * 5 }

      it '更新に失敗する' do
        put @password_path, params: password_params

        expect(response.status).to eq(422)
      end
    end

    context '新しいパスワードの組み合わせが20文字より多い' do
      let(:password) { "a" * 21 }
      let(:password_confirmation) { "b" * 21 }

      it '更新に失敗する' do
        put @password_path, params: password_params

        expect(response.status).to eq(422)
      end
    end
  end
end
