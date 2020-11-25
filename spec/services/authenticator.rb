require 'rails_helper'

describe Authenticator do
  describe '#authenticate' do
    it '正しいパスワードならtrueを返す' do
      user = build(:user)
      expect(Authenticator.new(user).authenticate('password')).to be_truthy
    end

    it '誤ったパスワードならfalseを返す' do
      user = build(:user)
      expect(Authenticator.new(user).authenticate('foobar')).to be_falsey
    end

    it 'パスワード未設定ならfalseを返す' do
      user = build(:user)
      expect(Authenticator.new(user).authenticate(nil)).to be_falsey
    end
  end
end
