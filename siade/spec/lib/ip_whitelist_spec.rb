RSpec.describe IpWhitelist do
  describe '.allowed?' do
    it 'allows any IP without whitelist' do
      expect(described_class.allowed?([], '8.8.8.8')).to be true
    end

    it 'allows an IP inside a whitelisted range' do
      expect(described_class.allowed?(['51.91.107.0/24'], '51.91.107.163')).to be true
    end

    it 'denies an IP outside every whitelisted range' do
      expect(described_class.allowed?(['51.91.107.0/24'], '8.8.8.8')).to be false
    end

    it 'denies a missing request IP' do
      expect(described_class.allowed?(['51.91.107.0/24'], nil)).to be false
    end

    it 'denies an unparsable request IP' do
      expect(described_class.allowed?(['51.91.107.0/24'], 'not-an-ip')).to be false
    end
  end
end
