require 'rails_helper'

RSpec.describe Todo, type: :model do
  let(:user) { create(:user) }

  describe '値の正規化' do
    it 'タイトルを半角カナで入力すると全角に変換' do
      todo = create(:todo, title: 'ﾃｽﾄ')
      expect(todo.title).to eq('テスト')
    end

    it 'タイトル前後の半角スペースを除去' do
      todo = create(:todo, title: ' テスト ')
      expect(todo.title).to eq('テスト')
    end
    
    it 'タイトル前後の全角スペースを除去' do
      todo = create(:todo, title: "\u{3000}テスト\u{3000}")
      expect(todo.title).to eq('テスト')
    end
  end

  describe 'バリデーション' do
    it 'todo_dateが空白の場合は無効' do
      todo = build(:todo, todo_date: nil)
      expect(todo).not_to be_valid
    end

    it '2000年1月1日より前の日付は無効' do
      todo = build(:todo, todo_date: Date.new(1999, 12, 31))
      expect(todo).not_to be_valid
    end

    it '1年後より後の日付は無効' do
      todo = build(:todo, todo_date: 1.year.since(Date.today) + 1.day)
      expect(todo).not_to be_valid
    end
    
    it 'ラベルの指定がなくても有効' do
      todo = build(:todo, label_id: nil)
      expect(todo).to be_valid
    end
  end
end
