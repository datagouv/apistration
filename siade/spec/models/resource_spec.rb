RSpec.describe Resource, type: :model do
  let(:instance) { described_class.new(params) }

  describe '#id' do
    subject { instance.id }

    context 'when params has an id key' do
      let(:params) do
        {
          id: valid_siren,
        }
      end

      it { is_expected.to eq(valid_siren) }
    end

    context 'when params has an no id key' do
      let(:params) do
        {
          id: nil,
        }
      end

      it { is_expected.to be_nil }
    end
  end
end
