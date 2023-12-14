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

    context 'タイトル' do
      subject { todo.title }
      let(:todo) { create(:todo, title: title) }

      context '半角カナで入力する場合' do
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

    context 'メモ' do
      subject { todo.body }
      let(:todo) { create(:todo, body: body) }

      context '半角カナで入力する場合' do
        let(:body) { 'ﾃｽﾄ' }

        it '全角に変換' do
          is_expected.to eq('テスト')
        end
      end

      context '前後に半角スペースを入力' do
        let(:body) { ' テスト ' }

        it '半角スペースを除去' do
          is_expected.to eq('テスト')
        end
      end

      context '前後に全角スペースを入力' do
        let(:body) { "\u{3000}テスト\u{3000}" }

        it '全角スペースを除去' do
          is_expected.to eq('テスト')
        end
      end
    end
  end

  describe 'バリデーション' do
    subject { todo }

    context 'タイトル' do
      let(:todo) { build(:todo, title: title) }

      context '空白の場合' do
        let(:title) { nil }

        it '無効' do
          is_expected.not_to be_valid
        end
      end

      context '40文字以上の場合' do
        let(:title) { 'a' * 41 }

        it '無効' do
          is_expected.not_to be_valid
        end
      end
    end

    context '日付' do
      let(:todo) { build(:todo, todo_date: todo_date) }

      context '空白の場合' do
        let(:todo_date) { nil }

        it '無効' do
          is_expected.not_to be_valid
        end
      end
    end

    context 'メモ' do
      let(:todo) { build(:todo, body: body) }

      context '空白の場合' do
        let(:body) { nil }

        it '有効' do
          is_expected.to be_valid
        end
      end
    end
  end
end
