require 'rails_helper'

RSpec.describe 'Passwords', type: :request do
  describe "Password" do
    let(:user) { create(:user, auto_generated_password: true) }

    before do
      sign_in_as(user)
      @password_path = "/api/v1/users/#{user.id}/password"
    end

    context '新しいパスワードの組み合わせが一致' do
      it '更新に成功する' do
        password_params = {
          change_password_form: {
            password: "newpassword",
            password_confirmation: "newpassword"
          }
        }

        put @password_path, params: password_params

        expect(response.status).to eq(200)
        expect(response.body).to include "パスワードが更新されました"
        expect(user.reload.auto_generated_password).to be false
        # expect(user.reload.password).to eq("newpassword")
      end
    end

    context '新しいパスワードの組み合わせが不一致' do
      it '更新に失敗する' do
        password_params = {
          change_password_form: {
            password: "a" * 10,
            password_confirmation: "b" * 10
          }
        }

        put @password_path, params: password_params

        expect(response.status).to eq(422)
        expect(user.reload.auto_generated_password).to be true
        expect(user.reload.password).to eq("password")
      end
    end

    context '新しいパスワードの組み合わせが6文字より少ない' do
      it '更新に失敗する' do
        password_params = {
          change_password_form: {
            password: "a" * 5,
            password_confirmation: "a" * 5
          }
        }

        put @password_path, params: password_params

        expect(response.status).to eq(422)
        expect(user.reload.auto_generated_password).to be true
        expect(user.reload.password).to eq("password")
      end
    end

    context '新しいパスワードの組み合わせが20文字より多い' do
      it '更新に失敗する' do
        password_params = {
          change_password_form: {
            password: "a" * 21,
            password_confirmation: "a" * 21
          }
        }

        put @password_path, params: password_params

        expect(response.status).to eq(422)
        expect(user.reload.password).to eq("password")
      end
    end
  end
end
