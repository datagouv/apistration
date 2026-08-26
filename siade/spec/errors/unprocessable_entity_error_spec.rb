RSpec.describe UnprocessableEntityError, type: :error do
  it_behaves_like 'a valid error' do
    let(:instance) { described_class.new(:siren) }
  end

  it_behaves_like 'a valid error' do
    let(:instance) { described_class.new(:gip_mds_too_many_individus) }
  end

  it_behaves_like 'a valid error' do
    let(:instance) { described_class.new(:sngi, provider: 'CNAF & MSA') }
  end

  describe '#meta' do
    it 'stays empty when no data provider was queried' do
      expect(described_class.new(:siren).meta).to eq({})
    end

    it 'exposes the queried data provider' do
      expect(described_class.new(:sngi, provider: 'CNAF & MSA').meta).to eq(provider: 'CNAF & MSA')
    end

    it 'keeps the provider first, ahead of the caller supplied meta' do
      instance = described_class.new(:civility, meta: { provider_error_code: 40_013 }, provider: 'CNAV')

      expect(instance.meta).to eq(provider: 'CNAV', provider_error_code: 40_013)
    end
  end

  describe '.build_example' do
    it 'omits the provider for an error raised before any provider call' do
      example = described_class.build_example(field: :siren, provider_name: 'INSEE')

      expect(example.meta).to eq({})
    end

    it 'fills the provider in for an error raised from a provider response' do
      example = described_class.build_example(field: :sngi, provider_name: 'CNAF & MSA', from_provider: true)

      expect(example.meta).to eq(provider: 'CNAF & MSA')
    end
  end
end
