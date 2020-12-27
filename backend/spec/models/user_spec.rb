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

  describe 'passwordの保存' do
    it '文字列を与えると、password_digestは長さ60の文字列になる' do
      expect(user.password_digest).to be_kind_of(String)
      expect(user.password_digest.size).to eq(60)
    end

    it 'nilを与えると、password_digestはnilになる' do
      user.password = nil
      expect(user.password_digest).to be_nil
    end

    it 'passwordが空欄の場合は無効' do
      expect(build(:user, password: nil)).not_to be_valid
    end

    it 'password_confirmationが空欄の場合は無効' do
      expect(build(:user, password_confirmation: nil)).not_to be_valid
    end

    it 'passwordとpassword_confirmationが異なる場合は無効' do
      user = build(:user, password: 'password', password_confirmation: 'password_confirmation')
      expect(user).not_to be_valid
    end
  end

  describe '値の正規化' do
    it 'username前後の半角スペースを除去' do
      user = create(:user, username: ' ユーザー ')
      expect(user.username).to eq('ユーザー')
    end

    it 'username前後の全角スペースを除去' do
      user = create(:user, username: "\u{3000}ユーザー\u{3000}")
      expect(user.username).to eq('ユーザー')
    end

    it 'emailに含まれる全角英数字を半角に変換' do
      user = create(:user, email: 'ｔｅｓｔ＠ｅｘａｍｐｌｅ．ｃｏｍ')
      expect(user.email).to eq('test@example.com')
    end

    it 'email前後の全角スペースを除去' do
      user = create(:user, email: "\u{3000}test@example.com\u{3000}")
      expect(user.email).to eq('test@example.com')
    end
  end

  describe 'バリデーション' do
    it 'ユーザー名が空欄の場合は無効' do
      expect(build(:user, username: nil)).not_to be_valid
    end

    it 'メールアドレスが空欄の場合は無効' do
      expect(build(:user, email: nil)).not_to be_valid
    end

    it '@を2個含むemailは無効' do
      expect(build(:user, email: 'test@@it.com')).not_to be_valid
    end

    it '他のユーザーのemailと重複したemailは無効' do
      user1 = create(:user)
      expect(user1.dup).not_to be_valid
    end

    it 'emailの大文字と小文字を区別しない' do
      user1 = create(:user)
      expect(build(:user, email: user1.email.upcase)).not_to be_valid
    end

    it 'passwordが空欄の場合は無効' do
      expect(build(:user, password: nil)).not_to be_valid
    end

    it 'password_confirmationがpasswordと一致していない場合は無効' do
      user = build(:user, password: "hogehoge", password_confirmation: "fugafuga")
      expect(user).not_to be_valid
    end

    it 'passwordが6文字より少ない場合は無効' do
      expect(build(:user, password: "hoge")).not_to be_valid
    end

    it 'passwordが20文字より多い場合は無効' do
      expect(build(:user, password: "hogehogehogehogehogehoge")).not_to be_valid
    end
  end
end
