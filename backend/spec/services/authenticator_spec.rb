require 'rails_helper'

RSpec.describe Authenticator, type: :service do
  describe 'authenticator' do
    let(:user) { build(:user) }
    
    it '正しければtrueを返す' do
      expect(Authenticator.new(user).authenticate('password')).to be true
    end
    
    it '誤っていればfalseを返す' do
      expect(Authenticator.new(user).authenticate('foobar')).to be false
    end
    
    it '未設定ならfalseを返す' do
      expect(Authenticator.new(user).authenticate(nil)).to be false
    end
  end
end
