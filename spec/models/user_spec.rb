require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe 'passwordの保存' do
    example '文字列を与えると、password_digestは長さ60の文字列になる' do
      user.password = 'password'
      expect(user.password_digest).to be_kind_of(String)
      expect(user.password_digest.size).to eq(60)
    end

    example 'nilを与えると、password_digestはnilになる' do
      user.password = nil
      expect(user.password_digest).to be_nil
    end

    example 'passwordが空欄の場合は無効' do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
    end

    example 'password_confirmationが空欄の場合は無効' do
      user = build(:user, password_confirmation: nil)
      expect(user).not_to be_valid
    end

    example 'passwordとpassword_confirmationが異なる場合は無効' do
      user = build(:user, password: 'password', password_confirmation: 'password_confirmation')
      expect(user).not_to be_valid
    end
  end

  describe '値の正規化' do
    example 'username前後の半角スペースを除去' do
      user = create(:user, username: ' ユーザー ')
      expect(user.username).to eq('ユーザー')
    end
    
    example 'username前後の全角スペースを除去' do
      user = create(:user, username: "\u{3000}ユーザー\u{3000}")
      expect(user.username).to eq('ユーザー')
    end

    example 'emailに含まれる全角英数字を半角に変換' do
      user = create(:user, email: 'ｔｅｓｔ＠ｅｘａｍｐｌｅ．ｃｏｍ')
      expect(user.email).to eq('test@example.com')
    end

    example 'email前後の全角スペースを除去' do
      user = create(:user, email: "\u{3000}test@example.com\u{3000}")
      expect(user.email).to eq('test@example.com')
    end
  end

  describe 'バリデーション' do
    example 'ユーザー名が空欄の場合は無効' do
      user = build(:user, username: nil)
      expect(user).not_to be_valid
    end

    example 'メールアドレスが空欄の場合は無効' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    example '@を2個含むemailは無効' do
      user = build(:user, email: 'test@@example.com')
      expect(user).not_to be_valid
    end

    example '他のユーザーのemailと重複したemailは無効' do
      user1 = create(:user)
      user2 = build(:user, email: user1.email)
      expect(user2).not_to be_valid
    end

    example 'emailの大文字と小文字を区別しない' do
      user1 = create(:user)
      user2 = build(:user, email: user1.email.upcase)
      expect(user2).not_to be_valid
    end
  end
end
