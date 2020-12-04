require 'rails_helper'

RSpec.describe Authenticator, type: :service do
  describe 'パスワードが' do
    let(:user) { build(:user) }
    
    it '正しければtrueを返す' do
      expect(Authenticator.new(user).authenticate('password')).to be_truthy
    end
    
    it '誤っていればfalseを返す' do
      expect(Authenticator.new(user).authenticate('foobar')).to be_falsey
    end
    
    it '未設定ならfalseを返す' do
      expect(Authenticator.new(user).authenticate(nil)).to be_falsey
    end
  end
end
