RSpec.describe ShortcutLabel, type: :model do
  describe 'Association' do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context 'shortcuts' do
      let(:target) { :shortcut }

      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'Shortcut' }
    end

    context 'labels' do
      let(:target) { :label }

      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'Label' }
    end
  end
end