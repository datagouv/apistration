RSpec.describe ApiGouvCommons::Siren do
  it 'accepts a Luhn-valid SIREN' do
    expect(described_class.valid?('418166096')).to be true
  end

  it 'rejects a 9-digit string that fails Luhn' do
    expect(described_class.valid?('418166097')).to be false
  end

  it 'rejects wrong length' do
    expect(described_class.valid?('12345678')).to be false
    expect(described_class.valid?('1234567890')).to be false
  end

  it 'accepts La Poste SIREN' do
    expect(described_class.valid?('356000000')).to be true
  end

  it 'rejects nil' do
    expect(described_class.valid?(nil)).to be false
  end

  it 'raises InvalidSirenError on validate! for a bad value' do
    expect { described_class.validate!('bogus', parameter: :siren) }
      .to raise_error(ApiGouvCommons::InvalidSirenError, /siren/)
  end
end
