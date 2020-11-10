require 'rails_helper'

RSpec.describe Shortcut, type: :model do
  let!(:user) { create(:user) }

  describe '値の正規化' do
    example 'タイトルを半角カナで入力すると全角に変換' do
      shortcut = create(:shortcut, title: 'ﾃｽﾄ')
      expect(shortcut.title).to eq('テスト')
    end

    example 'タイトル前後の余白を除去' do
      shortcut = create(:shortcut, title: ' テスト ')
      expect(shortcut.title).to eq('テスト')
    end
  end

  describe 'バリデーション' do
    example 'タイトルが空白の場合は無効' do
      shortcut = build(:shortcut, title: nil)
      expect(shortcut).not_to be_valid
    end

    example 'タイトルが重複している場合は無効' do
      shortcut1 = create(:shortcut)
      shortcut2 = build(:shortcut, title: shortcut1.title)
      expect(shortcut2).not_to be_valid
    end

    example '11個目以上は無効' do
      (1..Shortcut::MAX_SHORTCUT_COUNT).each do |i|
        shortcut = create(:shortcut, title: "タイトル_#{i}")
      end
      shortcut_extra = build(:shortcut)
      expect(shortcut_extra).not_to be_valid
      expect(user.shortcuts.count).to eq(10)
    end
  end
end
