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

      expect(response.status).to eq(200)
    end

    context 'todoの新規作成' do
      let(:todo_params) { 
        {
          todo: {
            title: "Todoタイトル",
            todo_date: Date.today
          }
        }
      }

      it '成功する' do
        post '/api/v1/todos', params: todo_params

        expect(response.status).to eq(201)
      end
    end

    context 'todoの更新' do
      let(:todo) { create(:todo, title: "old-title") }
      let(:todo_params) {
        {
          todo: {
            title: "new-title",
            todo_date: Date.tomorrow
          }
        }
      }

      it '成功する' do
        put "/api/v1/todos/#{todo.id}", params: todo_params

        expect(response.status).to eq(200)
      end
    end

    context 'todoの削除' do
      let(:todo) { create(:todo) }

      it '削除に成功する' do
        delete "/api/v1/todos/#{todo.id}"

        expect(response.status).to eq(200)
      end
    end

    context 'ステータスの切り替え' do
      let(:todo) { create(:todo) }

      it '成功する' do
        put "/api/v1/todos/#{todo.id}/toggle_status"

        expect(response.status).to eq(200)
      end
    end
  end
end
