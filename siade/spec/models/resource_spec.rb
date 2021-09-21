RSpec.describe Resource, type: :model do
  let(:instance) { described_class.new(params) }

  describe '#id' do
    subject { instance.id }

    context 'when params has an id key' do
      let(:params) do
        {
          id: valid_siren
        }
      end

      it { is_expected.to eq(valid_siren) }
    end

    context 'when params has an no id key' do
      let(:params) do
        {
          id: nil
        }
      end

      it { is_expected.to be_nil }
    end
  end

  describe '#to_h' do
    subject { instance.to_h }

    let(:params) do
      {
        id: 'id',
        payload: described_class.new(
          {
            key: 'value'
          }
        ),
        array: [
          'item',
          described_class.new(
            key: 'value'
          )
        ]
      }
    end

    it 'deeps transform to hash' do
      expect(subject).to eq(
        {
          id: 'id',
          payload: {
            key: 'value'
          },
          array: [
            'item',
            {
              key: 'value'
            }
          ]
        }
      )
    end
  end
end
