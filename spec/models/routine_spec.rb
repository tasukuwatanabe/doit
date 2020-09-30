require 'rails_helper'

RSpec.describe Routine, type: :model do
  let!(:user) { create(:user) }

  describe '値の正規化' do
    example 'タイトルを半角カナで入力すると全角に変換' do
      routine = create(:routine, title: 'ﾃｽﾄ')
      expect(routine.title).to eq('テスト')
    end

    example 'タイトル前後の余白を除去' do
      routine = create(:routine, title: ' テスト ')
      expect(routine.title).to eq('テスト')
    end
  end

  describe 'バリデーション' do
    example '開始日が空白の場合は無効' do
      routine = build(:routine, start_date: nil)
      expect(routine).not_to be_valid
    end

    example '開始日が2000年1月1日より前の日付は無効' do
      routine = build(:routine, start_date: Date.new(1999, 12, 31))
      expect(routine).not_to be_valid
    end

    example '終了日が2000年1月1日より前の日付は無効' do
      routine = build(:routine, end_date: Date.new(1999, 12, 31))
      expect(routine).not_to be_valid
    end

    example '終了日が開始日より先の場合は無効' do
      routine = build(:routine, start_date: Date.today, end_date: Date.yesterday)
      expect(routine).not_to be_valid
    end
  end
end
