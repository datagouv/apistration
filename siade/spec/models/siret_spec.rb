RSpec.describe Siret do
  it 'relies on SiretFormatValidator for validation' do
    siret = described_class.new(valid_siret)
    expect_any_instance_of(SiretFormatValidator).to receive(:validate_each)

    siret.valid?
  end

  it 'to_s' do
    expect(described_class.new(valid_siret).to_s).to eq(valid_siret)
  end
end
