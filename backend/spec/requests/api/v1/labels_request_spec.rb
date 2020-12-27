require 'rails_helper'

RSpec.describe 'Labels', type: :request do
  describe 'Label' do
    let(:user) { create(:user) }

    before do
      sign_in_as(user)
    end

    it '一覧を取得する' do
      10.times { create(:label, user: user ) }

      get '/api/v1/labels'

      json = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(json.length).to eq(10)
    end

    it '投稿に成功する' do
      label_params = {
        label: {
          title: "ラベルタイトル",
          color: "#123456"
        }
      }

      expect { post '/api/v1/labels', params: label_params }.to change(Label, :count).by(+1)

      expect(response.status).to eq(201)
    end

    it '更新に成功する' do
      label = create(:label, title: "old-title", color: "#123456")

      new_label_params = {
        label: {
          title: 'new-title',
          color: "#abcdef"
        }
      }

      put "/api/v1/labels/#{label.id}", params: new_label_params

      expect(response.status).to eq(200)
      expect(label.reload.title).to eq("new-title")
      expect(label.reload.color).to eq("#abcdef")
    end

    it '削除に成功する' do
      label = create(:label)

      expect { delete "/api/v1/labels/#{label.id}" }.to change(Label, :count).by(-1)

      expect(response.status).to eq(200)
    end
  end
end
