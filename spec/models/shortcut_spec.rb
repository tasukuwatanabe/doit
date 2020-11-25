require 'rails_helper'

RSpec.describe Shortcut, type: :model do
  let(:user) { create(:user) }

  describe '値の正規化' do
    it 'タイトルを半角カナで入力すると全角に変換' do
      shortcut = create(:shortcut, title: 'ﾃｽﾄ')
      expect(shortcut.title).to eq('テスト')
    end

    it 'タイトル前後の半角スペースを除去' do
      shortcut = create(:shortcut, title: ' テスト ')
      expect(shortcut.title).to eq('テスト')
    end
    
    it 'タイトル前後の全角スペースを除去' do
      shortcut = create(:shortcut, title: "\u{3000}テスト\u{3000}")
      expect(shortcut.title).to eq('テスト')
    end
  end

  describe 'バリデーション' do
    it 'タイトルが空白の場合は無効' do
      shortcut = build(:shortcut, title: nil)
      expect(shortcut).not_to be_valid
    end

    it 'タイトルが重複している場合は無効' do
      shortcut1 = create(:shortcut, user: user)
      shortcut2 = build(:shortcut, user: user)
      expect(shortcut2).not_to be_valid
    end

    it '11個目以上は無効' do
      (1..10).each do |i|
        shortcut = create(:shortcut, title: "タイトル_#{i}", user: user)
      end
      shortcut11 = build(:shortcut, user: user)
      expect(user.shortcuts.count).to eq(10)
    end
  end
end
