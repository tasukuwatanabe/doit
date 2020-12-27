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
    context 'タイトルを半角カナで入力' do
      it'全角に変換' do
        label = create(:label, title: 'ﾃｽﾄ')
        expect(label.title).to eq('テスト')
      end
    end

    context 'タイトル前後に半角スペースを入力' do
      it '半角スペースが除去される' do
        label = create(:label, title: ' テスト ')
        expect(label.title).to eq('テスト')
      end
    end
    
    context 'タイトル前後に全角スペースを入力' do
      it '全角スペースを除去' do
        label = create(:label, title: "\u{3000}テスト\u{3000}")
        expect(label.title).to eq('テスト')
      end
    end

    context 'カラーに大文字を入力' do
      it '小文字に変換される' do
        label = create(:label, color: "#ABCDEF")
        expect(label.color).to eq('#abcdef')
      end
    end
  end

  describe 'タイトルのバリデーション' do
    it '空白の場合は無効' do
      expect(build(:label, title: nil)).not_to be_valid
    end

    it '重複している場合は無効' do
      label1 = create(:label, title: "ラベルタイトル", user: user)
      expect(build(:label, title: "ラベルタイトル", user: user)).not_to be_valid
    end

    it '11個目以上は無効' do
      10.times { |i| create(:label, title: "タイトル#{i}", user: user) }
      expect { build(:label, user: user) }.not_to change(Label, :count)
    end
  end

  describe 'ラベルカラーのバリデーション' do
    it '空白の場合は無効' do
      expect(build(:label, color: nil)).not_to be_valid
    end

    it '重複している場合は有効' do
      2.times { create(:label, color: "#ff0011", user: user) }
      expect(Label.count).to eq(2)
    end

    it '16進数以外は無効' do
      expect(build(:label, color: '#abc12x')).not_to be_valid
    end
    
    it 'カラーが7文字なら無効' do
      expect(build(:label, color: '#abc12ac')).not_to be_valid
    end

    it 'カラーが3文字なら有効' do
      expect(create(:label, color: '#abc')).to be_valid
    end
  end
end
