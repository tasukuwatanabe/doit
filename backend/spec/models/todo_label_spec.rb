RSpec.describe TodoLabel, type: :model do
  describe 'Association' do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context 'todos' do
      let(:target) { :todo }

      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'Todo' }
    end

    context 'labels' do
      let(:target) { :label }

      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'Label' }
    end
  end
end