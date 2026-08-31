RSpec.describe ProviderUnprocessableEntityError, type: :error do
  described_class::SUBCODES.each_key do |reason|
    it_behaves_like 'a valid error' do
      let(:instance) { described_class.new('CNAV', reason) }
    end
  end

  it 'builds its code from the queried provider' do
    expect(described_class.new('CNAF & MSA', :unidentified_person).code).to eq('35560')
    expect(described_class.new('Sécurité sociale', :unidentified_person).code).to eq('36560')
  end

  it 'names the queried provider in meta' do
    expect(described_class.new('CNOUS', :rejected_identifier).meta).to eq(provider: 'CNOUS')
  end

  it 'keeps a 422 status' do
    expect(Errors::HTTPStatusForKind.call(described_class.new('CNAV', :rejected_civility).kind))
      .to eq(:unprocessable_content)
  end

  it 'raises on an unknown reason' do
    expect { described_class.new('CNAV', :whatever).code }.to raise_error(KeyError)
  end

  describe '#unidentified_person?' do
    it { expect(described_class.new('CNAV', :unidentified_person)).to be_unidentified_person }
    it { expect(described_class.new('CNAV', :rejected_civility)).not_to be_unidentified_person }
    it { expect(UnprocessableEntityError.new(:siren)).not_to be_unidentified_person }
  end
end
