RSpec.describe DGFIP::LiassesFiscales::RetrieveDictionariesFromCacheOrRemote, type: :interactor do
  subject(:call) { described_class.call(bundled_data:, params:) }

  let(:bundled_data) { BundledData.new(data: Resource.new(declarations:), context: {}) }
  let(:declarations) do
    [
      { numero_imprime: '2052', millesime: '202601' },
      { numero_imprime: '2050', millesime: 202_601 },
      { numero_imprime: '2033A', millesime: '202501' }
    ]
  end
  let(:params) { { year: 2025, user_id:, request_id: } }
  let(:user_id) { SecureRandom.uuid }
  let(:request_id) { SecureRandom.uuid }
  let(:available_dictionaries) { { '2025' => ['dictionary 2025'], '2026' => ['dictionary 2026'] } }

  before do
    allow(DGFIP::LiassesFiscales::RetrieveDictionaryFromCacheOrRemote).to receive(:call) do |params:|
      retrieved_dictionary(available_dictionaries[params[:year].to_s])
    end
  end

  def retrieved_dictionary(dictionary)
    Interactor::Context.build(dictionary:, errors: [ProviderUnavailable.new('DGFIP - Adélie')]).tap do |context|
      context.fail! if dictionary.nil?
    rescue Interactor::Failure
      context
    end
  end

  it { is_expected.to be_a_success }

  it 'retrieves one dictionary per declaration millesime year' do
    expect(call.dictionaries).to eq('2026' => ['dictionary 2026'], '2025' => ['dictionary 2025'])
  end

  it 'retrieves each dictionary once' do
    call

    expect(DGFIP::LiassesFiscales::RetrieveDictionaryFromCacheOrRemote).to have_received(:call).with(params: { year: '2026', user_id:, request_id: }).once
  end

  its(:default_dictionary_key) { is_expected.to eq('2025') }

  context 'when the dictionary of a millesime is not available' do
    let(:declarations) { [{ numero_imprime: '2052', millesime: '202701' }] }

    it { is_expected.to be_a_success }

    it 'falls back on the dictionary of the requested year' do
      expect(call.dictionaries).to eq('2027' => ['dictionary 2025'])
    end
  end

  context 'when the dictionary of a millesime is empty' do
    let(:available_dictionaries) { { '2025' => ['dictionary 2025'], '2026' => [] } }
    let(:declarations) { [{ numero_imprime: '2052', millesime: '202601' }] }

    it 'falls back on the dictionary of the requested year' do
      expect(call.dictionaries).to eq('2026' => ['dictionary 2025'])
    end
  end

  context 'when a declaration has no millesime' do
    let(:declarations) { [{ numero_imprime: '2052', millesime: nil }] }

    it 'uses the dictionary of the requested year' do
      expect(call.dictionaries).to eq('2025' => ['dictionary 2025'])
    end
  end

  context 'when neither the millesime nor the requested year dictionaries are available' do
    let(:available_dictionaries) { {} }

    it { is_expected.to be_a_failure }
    its(:errors) { is_expected.to all be_a(ProviderUnavailable) }
  end
end
