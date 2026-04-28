RSpec.describe ApiGouvCommons::Siret do
  describe '.valid?' do
    it 'accepts a Luhn-valid SIRET' do
      expect(described_class.valid?('13002526500013')).to be true
    end

    it 'accepts a La Poste SIRET even if Luhn fails' do
      expect(described_class.valid?('35600000000001')).to be true
    end

    it 'rejects a 14-digit string that fails Luhn' do
      expect(described_class.valid?('13002526500014')).to be false
    end

    it 'rejects wrong length' do
      expect(described_class.valid?('1234567890123')).to be false
      expect(described_class.valid?('123456789012345')).to be false
    end

    it 'rejects non-digit characters' do
      expect(described_class.valid?('1300252650001A')).to be false
    end

    it 'rejects nil and empty' do
      expect(described_class.valid?(nil)).to be false
      expect(described_class.valid?('')).to be false
    end
  end

  describe '.validate!' do
    it 'raises InvalidSiretError with the parameter name on failure' do
      expect { described_class.validate!('nope', parameter: :recipient) }
        .to raise_error(ApiGouvCommons::InvalidSiretError, /recipient/)
    end

    it 'is silent on a valid SIRET' do
      expect { described_class.validate!('13002526500013', parameter: :recipient) }.not_to raise_error
    end
  end
end
