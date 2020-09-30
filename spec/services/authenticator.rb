require 'rails_helper'

describe Authenticator do
  describe '#authenticate' do
    example '正しいパスワードならtrueを返す' do
      u = build(:user)
      expect(Authenticator.new(u).authenticate('password')).to be_truthy
    end

    example '誤ったパスワードならfalseを返す' do
      u = build(:user)
      expect(Authenticator.new(u).authenticate('foobar')).to be_falsey
    end

    example 'パスワード未設定ならfalseを返す' do
      u = build(:user)
      expect(Authenticator.new(u).authenticate(nil)).to be_falsey
    end
  end
end
