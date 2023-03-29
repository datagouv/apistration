RSpec.describe Resource do
  let(:instance) { described_class.new(params) }

  describe '#id' do
    subject { instance.id }

    context 'when params has an id key which is not nil' do
      let(:params) do
        {
          id: 'whatever'
        }
      end

      it { is_expected.to eq('whatever') }
    end

    context 'when params has a nil id key' do
      let(:params) do
        {
          id: nil
        }
      end

      it { is_expected.to be_nil }
    end

    context 'when params has a no id key' do
      let(:params) do
        {
          lol: 'whatever'
        }
      end

      it 'raises a no method error' do
        expect {
          subject
        }.to raise_error(NoMethodError)
      end
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

  describe 'deep_merge' do
    subject { instance.deep_merge!(to_nil) }

    let(:params) do
      {
        id: 'id',
        payload: {
          key: 'value',
          key1: 'value1'
        }
      }
    end

    let(:to_nil) do
      {
        id: nil,
        payload: {
          key: nil
        }
      }
    end

    it 'replaces deep values with a deep merge' do
      expect(subject).to eq(
        {
          id: nil,
          payload: {
            key: nil,
            key1: 'value1'
          }
        }
      )
    end
  end
end
