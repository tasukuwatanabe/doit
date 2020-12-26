require 'rails_helper'

RSpec.describe Label, type: :model do
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

    context 'shortcut_labels' do
      let(:target) { :shortcut_labels }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'ShortcutLabel' }
    end
  end

  describe '値の正規化' do
    it 'タイトルを半角カナで入力すると全角に変換' do
      label = create(:label, title: 'ﾃｽﾄ')
      expect(label.title).to eq('テスト')
    end

    it 'タイトル前後の半角スペースを除去' do
      label = create(:label, title: ' テスト ')
      expect(label.title).to eq('テスト')
    end
    
    it 'タイトル前後の全角スペースを除去' do
      label = create(:label, title: "\u{3000}テスト\u{3000}")
      expect(label.title).to eq('テスト')
    end
  end

  describe 'タイトルのバリデーション' do
    it '空白の場合は無効' do
      label = build(:label, title: nil)
      expect(label).not_to be_valid
    end

    it '重複している場合は無効' do
      label1 = create(:label, user: user)
      label2 = build(:label, user: user)
      expect(label2).not_to be_valid
    end

    it '11個目以上は無効' do
      (1..10).each do |i|
        label = create(:label, title: "タイトル_#{i}", user: user)
      end
      label11 = build(:label, user: user)
      expect(user.labels.count).to eq(10)
    end
  end

  describe 'ラベルカラーのバリデーション' do
    it '空白の場合は無効' do
      label = build(:label, color: nil)
      expect(label).not_to be_valid
    end

    it '重複している場合は有効' do
      label1 = create(:label, title: "タイトル1", color: "#ff0011", user: user)
      label2 = create(:label, title: "タイトル2", color: "#ff0011", user: user)
      expect(label2).to be_valid
    end

    it '16進数以外は無効' do
      label = build(:label, color: '#abc12o')
      expect(label).not_to be_valid
    end
    
    it 'カラーが7文字なら無効' do
      label = build(:label, color: '#abc12ac')
      expect(label).not_to be_valid
    end

    it 'カラーが3文字なら有効' do
      label = create(:label, color: '#abc')
      expect(label).to be_valid
    end

    it 'カラーが大文字なら小文字に変換' do
      label = create(:label, color: '#ABCDEF')
      expect(label.color).to eq('#abcdef')
    end
  end
end
