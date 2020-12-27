require 'rails_helper'

RSpec.describe 'Todos', type: :request do
  describe 'Todo' do
    let(:user) { create(:user) }

    before do
      sign_in_as(user)
    end

    it '一覧を取得する' do
      10.times { create(:todo, user: user ) }

      get '/api/v1/todos', params: { date: Date.today }

      json = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(json.length).to eq(10)
    end

    it '投稿に成功する' do
      todo_params = { title: "Todoタイトル", todo_date: Date.today }

      expect { post '/api/v1/todos', params: { todo: todo_params } }.to change(Todo, :count).by(+1)

      expect(response.status).to eq(201)
    end

    it '更新に成功する' do
      todo = create(:todo, title: "old-title")

      todo_params = { 
        todo: { 
          title: 'new-title' 
        }
      }

      put "/api/v1/todos/#{todo.id}", params: todo_params

      expect(response.status).to eq(200)
      expect(todo.reload.title).to eq("new-title")
    end

    it '削除に成功する' do
      todo = create(:todo)

      expect { delete "/api/v1/todos/#{todo.id}" }.to change(Todo, :count).by(-1)

      expect(response.status).to eq(200)
    end

    it 'ステータスの切り替えに成功する' do
      todo = create(:todo)

      put "/api/v1/todos/#{todo.id}/toggle_status"

      expect(todo.reload.status).to be(true)
    end
  end
end
