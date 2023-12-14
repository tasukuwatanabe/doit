require 'rails_helper'

RSpec.describe Shortcut, type: :model do
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
    context 'タイトル' do
      subject { shortcut.title }
      let(:shortcut) { create(:shortcut, title: title) }

      context '半角カナで入力' do
        let(:title) { 'ﾃｽﾄ' }

        it '全角に変換' do
          is_expected.to eq('テスト')
        end
      end

      context '前後に半角スペースを入力' do
        let(:title) { ' テスト ' }

        it '半角スペースを除去' do
          is_expected.to eq('テスト')
        end
      end

      context '前後に全角スペースを入力' do
        let(:title) { "\u{3000}テスト\u{3000}" }

        it '全角スペースを除去' do
          is_expected.to eq('テスト')
        end
      end
    end
  end

  describe 'バリデーション' do
    let(:user) { create(:user) }
    subject { shortcut }

    context 'タイトル' do
      let(:shortcut) { build(:shortcut, title: title, user: user) }

      context '空白の場合' do
        let(:title) { nil }

        it '無効' do
          is_expected.not_to be_valid
        end
      end

      context '同じユーザーで重複' do
        let(:title) { "重複したタイトル" }

        it '無効' do
          shortcut.save
          expect(shortcut.dup).not_to be_valid
        end
      end
    end

    context '個数' do
      context '11個以上の登録' do
        it '無効' do
          10.times { create(:shortcut, user: user) }
          expect(user.shortcuts.count).to eq(10)
          expect{ build(:shortcut, user: user) }.not_to change(Shortcut, :count)
        end
      end
    end
  end
end
