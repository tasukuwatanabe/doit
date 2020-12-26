require 'rails_helper'

RSpec.describe 'Todos', type: :request do
  describe 'Todoの' do
    let(:user) { create(:user) }

    before do
      sign_in_as(user)
    end

    it "一覧を取得する" do
      get '/api/v1/todos'
      expect(response.status).to eq(200)
    end
  end
end
