require 'rails_helper'

RSpec.describe Authenticator, type: :service do
  describe 'authenticator' do
    subject { authenticate }
    let(:user) { create(:user) }
    let(:authenticate) { Authenticator.new(user).authenticate(password) }

    context '正しい場合' do
      let(:password) { user.password }

      it 'trueを返す' do
        is_expected.to be true
      end
    end
    
    context '誤っている場合' do
      let(:password) { 'wrong_password' }

      it 'falseを返す' do
        is_expected.to be false
      end
    end
    
    context 'nilの場合' do
      let(:password) { nil }

      it 'falseを返す' do
        is_expected.to be false
      end
    end
  end
end
