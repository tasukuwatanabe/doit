require 'rails_helper'

RSpec.describe UserForm, type: :model do
  describe "#save" do
    subject { user_form.save }
    let(:user_form) { UserForm.new(user, params) }

    context "user を更新する" do
      let(:user) { create(:user) }

      context "username を更新する" do
        let(:params) { { username: username } }

        context "username が 20文字以下の場合" do
          let(:username) { "更新タロウ" }
          it "username の更新が成功する" do
            is_expected.to eq true
            expect(user.username).to eq username
          end
        end

        context "username が 21文字以上の場合" do
          let(:username) { Array.new(21, "a").join }
          it "username の更新が成功する" do
            is_expected.to eq false
          end
        end
      end

      context "email を更新する" do
        let(:params) { { email: email } }
        let(:email) { "update@example.com" }

        it "email は unconfirmed_email カラムに保存されて、token なども同時に登録する" do
          old_email = user.email
          is_expected.to eq true
          expect(user.email).to eq old_email
          expect(user.unconfirmed_email).to eq email
          expect(user.confirmation_token).not_to eq nil
          expect(user.confirmation_digest).not_to eq nil
          expect(user.confirmation_sent_at).not_to eq nil
        end

        context "すでに使用されている email に更新する" do
          before { create(:user, email: "already@example.com") }
          let(:params) { { email: "already@example.com" } }

          it "更新できない" do
            is_expected.to eq false
          end
        end
      end
    end
  end
end
