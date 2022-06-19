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

      context "画像" do
        let(:user) { create(:user, user_image: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/files/download.jpg'))) }

        context "remove_user_image の値が '1' の時" do
          let(:params) { { remove_user_image: "1" } }

          it "画像がデフォルト画像になる" do
            is_expected.to eq true
            expect(user.user_image.url).to eq "http://localhost:3000/user_icons/default.jpg"
          end
        end

        context "remove_user_image の値が '1' 以外の時" do
          let(:params) { { remove_user_image: "0" } }

          it "画像は変更しない" do
            is_expected.to eq true
            expect(user.user_image.url).to eq  "http://localhost:3000/user_icons/user_#{user.id}.jpg"
          end
        end
      end
    end
  end
end
