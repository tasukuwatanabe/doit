require 'rails_helper'

RSpec.describe 'Shortcuts', type: :request do
  describe 'Shortcut' do
    let(:user) { create(:user) }

    before do
      sign_in_as(user)
    end

    it '一覧を取得する' do
      10.times { create(:shortcut, user: user ) }

      get '/api/v1/shortcuts'

      json = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(json.length).to eq(10)
    end

    it '投稿に成功する' do
      shortcut_params = { 
        shortcut: {
          title: "ショートカットタイトル", 
          color: "#123456" 
        }
      }

      expect { post '/api/v1/shortcuts', params: shortcut_params }.to change(Shortcut, :count).by(+1)

      expect(response.status).to eq(201)
    end

    it '更新に成功する' do
      shortcut = create(:shortcut, title: "old-title")
      
      shortcut_params = { 
        shortcut: { 
          title: 'new-title' 
        } 
      }

      put "/api/v1/shortcuts/#{shortcut.id}", params: shortcut_params

      expect(response.status).to eq(200)
      expect(shortcut.reload.title).to eq("new-title")
    end

    it '削除に成功する' do
      shortcut = create(:shortcut)

      expect { delete "/api/v1/shortcuts/#{shortcut.id}" }.to change(Shortcut, :count).by(-1)

      expect(response.status).to eq(200)
    end
  end
end
