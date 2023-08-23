RSpec.describe ProxiedFileService, type: :service do
  let(:url) { 'https://www.example.com/document.pdf' }

  describe '.set' do
    subject { described_class.set(url) }

    it 'renders a unique token' do
      expect(subject).to be_a(String)
    end

    context 'when redis fail to connect' do
      before do
        allow(RedisService).to receive(:instance).and_raise(Redis::BaseConnectionError)
      end

      it 'raises an error' do
        expect { subject }.to raise_error(ProxiedFileService::ConnectionError)
      end
    end
  end

  describe '.get' do
    subject { described_class.get(token) }

    let(:token) { described_class.set(url) }

    it { is_expected.to eq(url) }

    context 'when redis fail to connect' do
      before do
        allow(RedisService).to receive(:instance).and_raise(Redis::BaseConnectionError)
      end

      it 'raises an error' do
        expect { subject }.to raise_error(ProxiedFileService::ConnectionError)
      end
    end
  end
end
