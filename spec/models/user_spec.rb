require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'passwordの保存' do
    example '文字列を与えると、password_digestは長さ60の文字列になる' do
      user = User.new
      user.password = 'password'
      expect(user.password_digest).to be_kind_of(String)
      expect(user.password_digest.size).to eq(60)
    end

    example 'nilを与えると、password_digestはnilになる' do
      user = User.new(password_digest: 'password')
      user.password = nil
      expect(user.password_digest).to be_nil
    end
  end

  describe '値の正規化' do
    example 'username前後の空白を除去' do
      user = create(:user, username: ' testuser ')
      expect(user.username).to eq('testuser')
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
