RSpec.describe DummyPingDriver, type: :ping_driver do
  describe '#perform' do
    subject(:make_ping) { described_class.new(params).perform }

    let(:params) { {} }

    it { is_expected.to eq(:unknown) }
  end
end
