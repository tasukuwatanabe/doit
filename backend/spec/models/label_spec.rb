require 'rails_helper'

RSpec.describe Label, type: :model do
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

    context 'タイトル' do
      subject { label.title }
      let(:label) { create(:label, title: title) }

      context '半角カナで入力' do
        let(:title) { 'ﾃｽﾄ' }

        it'全角に変換' do
          is_expected.to eq('テスト')
        end
      end

      context '前後に半角スペースを入力' do
        let(:title) { ' テスト ' }

        it'半角スペースが除去される' do
          is_expected.to eq('テスト')
        end
      end

      context '前後に全角スペースを入力' do
        let(:title) { "\u{3000}テスト\u{3000}" }

        it'全角スペースが除去される' do
          is_expected.to eq('テスト')
        end
      end
    end

    context 'カラー' do
      subject { label.color }
      let(:label) { create(:label, color: color) }

      context '全角文字で入力' do
        let(:color) { "#ABCDEF" }

        it'半角に変換される' do
          is_expected.to eq('#abcdef')
        end
      end
    end
  end

  describe 'バリデーション' do
    let(:user) { create(:user) }
    subject { label }

    context 'タイトル' do
      let(:label) { build(:label, title: title, user: user) }

      context '空白の場合' do
        let(:title) { nil }

        it '無効' do
          is_expected.not_to be_valid
        end
      end

      context '同じユーザーで重複' do
        let(:title) { "重複したタイトル"}

        it '無効' do
          label.save
          expect(label.dup).not_to be_valid
        end
      end
    end

    context 'カラー' do
      let(:label) { build(:label, color: color, user: user) }

      context '空白の場合' do
        let(:color) { nil }

        it '無効' do
          is_expected.not_to be_valid
        end
      end

      context '重複している場合' do
        let(:color) { "#123abc" }

        it '有効' do
          is_expected.to be_valid
        end
      end

      context '16進数以外' do
        let(:color) { '#abc12x' }

        it '無効' do
          is_expected.not_to be_valid
        end
      end

      context 'カラーが7文字' do
        let(:color) { '#abc12ac' }

        it '無効' do
          is_expected.not_to be_valid
        end
      end

      context 'カラーが3文字' do
        let(:color) { '#abc' }

        it '有効' do
          is_expected.to be_valid
        end
      end
    end

    context '個数' do
      context '11個以上の登録' do
        it '無効' do
          10.times { create(:label, user: user) }
          expect(user.labels.count).to eq(10)
          expect{ build(:label, user: user) }.not_to change(Label, :count)
        end
      end
    end
  end
end
