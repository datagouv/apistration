RSpec.describe INSEE::AcceptedPassword do
  describe '.last?' do
    it 'recognizes the password INSEE accepted last' do
      described_class.remember!('Accepted#Password1')

      expect(described_class.last?('Accepted#Password1')).to be(true)
    end

    it 'rejects any other password' do
      described_class.remember!('Accepted#Password1')

      expect(described_class.last?('Another#Password1')).to be(false)
    end

    it 'knows nothing before a first acceptance' do
      expect(described_class.last?('Accepted#Password1')).to be(false)
    end

    it 'knows nothing once forgotten' do
      described_class.remember!('Accepted#Password1')
      described_class.forget!

      expect(described_class.last?('Accepted#Password1')).to be(false)
    end

    it 'keeps it outside the application namespace, which changes on every boot' do
      described_class.remember!('Accepted#Password1')

      expect(Rails.cache.read(described_class::CACHE_KEY)).to be_nil
      expect(Rails.cache.read(described_class::CACHE_KEY, namespace: described_class::CACHE_NAMESPACE)).to be_present
    end
  end

  describe '.remember!' do
    it 'keeps a fingerprint, never the password itself' do
      described_class.remember!('Accepted#Password1')

      expect(Rails.cache.read(described_class::CACHE_KEY, namespace: described_class::CACHE_NAMESPACE))
        .not_to include('Accepted#Password1')
    end
  end
end
