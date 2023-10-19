RSpec.describe RedisService, type: :service do
  let(:instance) { described_class.new }

  describe 'when redis is not available' do
    before do
      allow(instance).to receive(:redis).and_raise(Redis::BaseConnectionError)
    end

    describe '#get' do
      it 'does not raise an error' do
        expect { instance.get('whatever') }.not_to raise_error
      end
    end

    describe '#set' do
      it 'does not raise an error' do
        expect { instance.set('whatever', 'whatever', ex: 1) }.not_to raise_error
      end
    end
  end
end
