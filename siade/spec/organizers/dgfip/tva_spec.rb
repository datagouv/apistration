RSpec.describe DGFIP::TVA, type: :retriever_organizer do
  subject(:call) { described_class.call(params:) }

  let(:params) { { siren: } }
  let(:tabular_api_endpoint) do
    %r{#{DGFIP::TVA::MakeRequest::BASE_URL}/api/resources/.+/data/}
  end

  describe 'when the SIREN only has the number computed with the numeric key' do
    let(:siren) { '217500016' }

    before { mock_valid_dgfip_numero_tva(siren, rows: [{ vat_no: '72217500016', issued_date: '2004-01-05' }]) }

    it { is_expected.to be_a_success }

    it 'returns the computed number' do
      expect(call.bundled_data.data.numero_tva).to eq('FR72217500016')
    end

    it 'exposes the dataset refresh date in the resource' do
      expect(call.bundled_data.data.date_derniere_mise_a_jour).to eq('2026-06-11')
    end
  end

  describe 'when the SIREN only has a number with an alphanumeric key' do
    let(:siren) { '391196425' }

    before { mock_valid_dgfip_numero_tva(siren, rows: [{ vat_no: '0F391196425', issued_date: '2004-01-05' }]) }

    it 'returns this number' do
      expect(call.bundled_data.data.numero_tva).to eq('FR0F391196425')
    end
  end

  describe 'when the SIREN has several numbers including the computed one' do
    let(:siren) { '200071900' }

    before do
      mock_valid_dgfip_numero_tva(siren, rows: [
        { vat_no: '82200071900', issued_date: '2017-01-01' },
        { vat_no: '8K200071900', issued_date: '2017-10-01' },
        { vat_no: 'AM200071900', issued_date: '2020-01-01' }
      ])
    end

    it 'returns the computed number, even if another one was issued more recently' do
      expect(call.bundled_data.data.numero_tva).to eq('FR82200071900')
    end
  end

  describe 'when the SIREN has several numbers without the computed one' do
    let(:siren) { '200071900' }

    before do
      mock_valid_dgfip_numero_tva(siren, rows: [
        { vat_no: '8K200071900', issued_date: '2017-10-01' },
        { vat_no: 'AM200071900', issued_date: '2020-01-01' },
        { vat_no: '4W200071900', issued_date: '2017-01-01' }
      ])
    end

    it 'returns the most recently issued number' do
      expect(call.bundled_data.data.numero_tva).to eq('FRAM200071900')
    end
  end

  describe 'when the SIREN is absent from the DGFIP dataset' do
    let(:siren) { '217500016' }

    before { mock_dgfip_numero_tva_not_found(siren) }

    it { is_expected.to be_a_failure }
    its(:errors) { is_expected.to include(an_instance_of(NotFoundError)) }
  end

  describe 'in sandbox, for the SIREN of the alphanumeric key mock' do
    subject(:call) { described_class.call(params:, operation_id: 'api_entreprise_v3_dgfip_tva', recipient: '13002526500013') }

    let(:siren) { '391196425' }

    before { allow(Rails.env).to receive(:staging?).and_return(true) }

    it { is_expected.to be_a_success }

    it 'renders the mocked number' do
      expect(call.mocked_data[:payload].dig('data', 'numero_tva')).to eq('FR0F391196425')
    end
  end

  describe 'with an invalid SIREN' do
    let(:siren) { 'lol' }

    it { is_expected.to be_a_failure }
    its(:errors) { is_expected.to include(an_instance_of(UnprocessableEntityError)) }
  end

  describe 'when the upstream resource id is misconfigured (404)' do
    let(:siren) { '217500016' }

    before do
      stub_request(:get, tabular_api_endpoint)
        .to_return(status: 404, body: '404: Not Found')
    end

    it { is_expected.to be_a_failure }
    its(:errors) { is_expected.to include(an_instance_of(ProviderUnavailable)) }
  end
end
