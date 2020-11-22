require 'rails_helper'

describe Authenticator do
  describe '#authenticate' do
    example '正しいパスワードならtrueを返す' do
      user = build(:user)
      expect(Authenticator.new(user).authenticate('password')).to be_truthy
    end

    example '誤ったパスワードならfalseを返す' do
      user = build(:user)
      expect(Authenticator.new(user).authenticate('foobar')).to be_falsey
    end

    example 'パスワード未設定ならfalseを返す' do
      user = build(:user)
      expect(Authenticator.new(user).authenticate(nil)).to be_falsey
    end
  end
end
