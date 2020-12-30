require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe '.connection_config' do
    subject { described_class.connection_config[:database] }

    it '指定のDBに接続していること' do
      is_expected.to match(/doit_test/)
      is_expected.not_to match(/doit_development/)
    end
  end

  # アソシエーションのテスト
  describe 'Association' do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context 'todos' do
      let(:target) { :todos }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Todo' }
    end

    context 'shortcuts' do
      let(:target) { :shortcuts }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Shortcut' }
    end

    context 'labels' do
      let(:target) { :labels }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Label' }
    end
  end

  describe '値の正規化' do

    context 'username' do
      subject { user.username }
      let(:user) { create(:user, username: username)}

      context '前後に半角スペースを入力' do
        let(:username) { ' ユーザー ' }

        it '半角スペースを除去' do
          is_expected.to eq('ユーザー')
        end
      end

      context '前後に全角スペースを入力' do
        let(:username) { "\u{3000}ユーザー\u{3000}" }

        it '全角スペースを除去' do
          is_expected.to eq('ユーザー')
        end
      end
    end

    context 'email' do
      subject { user.email }
      let(:user) { create(:user, email: email)}

      context '全角英数字で入力' do
        let(:email) { 'ｔｅｓｔ＠ｅｘａｍｐｌｅ．ｃｏｍ' }

        it '全角英数字を半角に変換' do
          is_expected.to eq('test@example.com')
        end
      end

      context '全角スペースで入力' do
        let(:email) { "\u{3000}test@example.com\u{3000}" }

        it '全角スペースを除去' do
          is_expected.to eq('test@example.com')
        end
      end

      context '大文字で入力' do
        let(:email) { 'TEST＠EXAMPLE.COM' }

        it '小文字に変換' do
          is_expected.to eq('test@example.com')
        end
      end
    end
  end

  describe 'バリデーション' do
    subject { user }

    context 'username' do
      let(:user) { build(:user, username: username) }

      context '空欄の場合' do
        let(:username) { nil }

        it '無効' do
          is_expected.not_to be_valid
        end
      end
    end

    context 'email' do
      let(:user) { build(:user, email: email) }

      context '空欄の場合' do
        let(:email) { nil }

        it '無効' do
          is_expected.not_to be_valid
        end
      end

      context '@を2個含む' do
        let(:email) { 'test@@example.com' }

        it '無効' do
          is_expected.not_to be_valid
        end
      end

      context '大文字と小文字との区別' do
        let(:email) { 'test@example.com' }

        it '区別しない' do
          user.save
          expect(build(:user, email: user.email.upcase!)).not_to be_valid
        end
      end

      context '他のユーザーと重複' do
        let(:email) { 'duplicate@example.com' }

        it '無効' do
          user.save
          expect(build(:user, email: "duplicate@example.com")).not_to be_valid
        end
      end
    end

    context 'password' do
      let(:user) { build(:user, password: password) }

      context '空欄の場合' do
        let(:password) { nil }

        it '無効' do
          is_expected.not_to be_valid
        end
      end

      context '6文字より少ない場合' do
        let(:password) { 'a' * 5 }

        it '無効' do
          is_expected.not_to be_valid
        end
      end

      context '20文字より多い場合' do
        let(:password) { 'a' * 21 }

        it '無効' do
          is_expected.not_to be_valid
        end
      end
    end

    context 'password_confirmation' do
      let(:user) { build(:user, password_confirmation: password_confirmation) }

      context 'password一致していない場合' do
        let(:password_confirmation) { "wrong_confirmation" }

        it '無効' do
          is_expected.not_to be_valid
        end
      end
    end

    context 'unconfirmed_email' do
      context '他のユーザーのemailと重複' do
        let(:user1) { create(:user, email: 'already@example.com') }
        let(:user2) { build(:user, unconfirmed_email: user1.email) }

        it '無効' do
          expect(user2).not_to be_valid
          expect(user2.errors.messages[:unconfirmed_email]).to include "はすでに存在します"
        end
      end
    end
  end

  describe 'データの保存' do

    context 'password_digest' do
      subject { user.password_digest }
      let(:user) { build(:user, password: password) }

      context 'passwordに文字列を与える' do
        let(:password) { "password" }

        it '長さ60の文字列になる' do
          user.save
          is_expected.to be_kind_of(String)
          expect(user.password_digest.size).to eq(60)
        end
      end

      context 'passwordにnilを与えると' do
        let(:password) { nil }

        it 'nilになる' do
          user.save
          is_expected.to be_nil
        end
      end
    end
  end
end
