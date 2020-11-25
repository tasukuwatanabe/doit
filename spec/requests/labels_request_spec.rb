require 'rails_helper'

RSpec.describe 'Labels', type: :request do
  describe 'Labelの' do
    let(:user) { create(:user) }

    before do
      sign_in_as(user)
    end

    it '一覧を取得する' do
      get '/api/labels'
      expect(response.status).to eq(200)
    end
  end
end
