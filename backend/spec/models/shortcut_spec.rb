require 'rails_helper'

RSpec.describe Shortcut, type: :model do
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

    context 'shortcut_labels' do
      let(:target) { :shortcut_labels }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'ShortcutLabel' }
    end
  end

  describe '値の正規化' do
    context 'タイトルを半角カナで入力' do
      it '全角に変換' do
        shortcut = create(:shortcut, title: 'ﾃｽﾄ')
        expect(shortcut.title).to eq('テスト')
      end
    end

    context 'タイトル前後に半角スペースを入力' do
      it '半角スペースを除去' do
        shortcut = create(:shortcut, title: ' テスト ')
        expect(shortcut.title).to eq('テスト')
      end
    end
    
    context 'タイトル前後に全角スペースを入力' do
      it '全角スペースを除去' do
        shortcut = create(:shortcut, title: "\u{3000}テスト\u{3000}")
        expect(shortcut.title).to eq('テスト')
      end
    end
  end

  describe 'バリデーション' do
    it 'タイトルが空白の場合は無効' do
      expect(build(:shortcut, title: nil)).not_to be_valid
    end

    it 'タイトルが重複している場合は無効' do
      shortcut1 = create(:shortcut, title: "重複したタイトル", user: user)
      expect(shortcut1.dup).not_to be_valid
    end

    it '11個目以上は無効' do
      10.times { |i| create(:shortcut, user: user) }
      expect { build(:shortcut, user: user) }.not_to change(Shortcut, :count)
    end
  end
end
