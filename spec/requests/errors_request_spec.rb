require 'rails_helper'

RSpec.describe "Errors", type: :request do
  describe 'GET 404' do
    let(:user) { create(:user) }

    it '404ページが表示される' do
      sign_in_as(user)

      get '/notfound'

      expect(response.status).to eq(200)
    end
  end
end
