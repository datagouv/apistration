RSpec.describe TVAIntracommunautaire, type: :service do
  describe '#perform' do
    subject { described_class.new(siren).perform }

    let(:siren) { '404833048' }

    it { is_expected.to eq('FR83404833048') }
  end

  describe '#candidates' do
    subject(:candidates) { described_class.new(siren).candidates }

    let(:siren) { '200071900' }

    it 'starts with the number computed with the numeric key' do
      expect(candidates.first).to eq('FR82200071900')
    end

    it 'covers every alphanumeric key published by the DGFIP for this SIREN' do
      expect(candidates).to include('FR8K200071900', 'FR4W200071900', 'FRAM200071900', 'FR7X200071900')
    end

    it 'covers the alphanumeric key of a SIREN having no numeric key number' do
      expect(described_class.new('391196425').candidates).to include('FR0F391196425')
    end

    it 'has 96 alphanumeric keys besides the numeric one' do
      expect(candidates.size).to eq(97)
    end
  end
end
