require 'rails_helper'

RSpec.describe 'Shortcuts', type: :request do
  describe 'Shortcutの' do
    let(:user) { create(:user) }

    before do
      sign_in_as(user)
    end

    it '一覧を取得する' do
      get '/api/shortcuts'
      expect(response.status).to eq(200)
    end
  end
end
