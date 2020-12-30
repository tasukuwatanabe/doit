require 'rails_helper'

RSpec.describe ChangePasswordForm, type: :form do
  describe "バリデーションのチェック" do
    let(:user) { create(:user) }

    context "パスワードが6文字より少ない場合" do
      it "パスワードの更新に失敗する" do
        password_params = {
          password: "a" * 5,
          password_confirmation: "a" * 5
        }
        change_password_form = ChangePasswordForm.new(user, password_params)
        change_password_form.valid?
        expect(change_password_form.errors[:password]).to be_present
      end
    end

    context "パスワードが20文字より多い場合" do
      it "パスワードの更新に失敗する" do
        password_params = {
          password: "a" * 21,
          password_confirmation: "a" * 21
        }
        change_password_form = ChangePasswordForm.new(user, password_params)
        change_password_form.valid?
        expect(change_password_form.errors[:password]).to be_present
      end
    end

    context "パスワードが確認用と一致しない場合" do
      it "パスワードの更新に失敗する" do
        password_params = {
          password: "a" * 10,
          password_confirmation: "b" * 10
        }
        change_password_form = ChangePasswordForm.new(user, password_params)
        change_password_form.valid?
        expect(change_password_form.errors[:password_confirmation]).to be_present
      end
    end
  end
end