require 'rails_helper'

RSpec.describe Todo, type: :model do
  let!(:user) { create(:user) }
  let!(:todo_parent) { create(:todo_parent) }

  describe '値の正規化' do
    example 'タイトルを半角カナで入力すると全角に変換' do
      todo = create(:todo, title: 'ﾃｽﾄ')
      expect(todo.title).to eq('テスト')
    end

    example 'タイトル前後の余白を除去' do
          todo = create(:todo, title: ' テスト ')
      expect(todo.title).to eq('テスト')
    end
  end

  describe 'バリデーション' do
    example 'todo_dateが空白の場合は無効' do
      todo = build(:todo, todo_date: nil)
      expect(todo).not_to be_valid
    end

    example '2000年1月1日より前の日付は無効' do
      todo = build(:todo, todo_date: Date.new(1999, 12, 31))
      expect(todo).not_to be_valid
    end

    example '1年後より後の日付は無効' do
      todo = build(:todo, todo_date: 1.year.since(Date.today) + 1.day)
      expect(todo).not_to be_valid
    end
  end
end
