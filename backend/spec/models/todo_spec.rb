require 'rails_helper'

RSpec.describe Todo, type: :model do
  let(:user) { create(:user) }

  describe 'Association' do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context 'users' do
      let(:target) { :user }

      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'User' }
    end

    context 'todo_labels' do
      let(:target) { :todo_labels }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'TodoLabel' }
    end
  end

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
      expect(build(:todo, todo_date: nil)).not_to be_valid
    end
    
    it 'ラベルの指定がなくても有効' do
      expect(build(:todo, label_ids: [])).to be_valid
    end
  end
end
