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
  end
end
