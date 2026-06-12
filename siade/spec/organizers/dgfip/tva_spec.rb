RSpec.describe DGFIP::TVA, type: :retriever_organizer do
  subject(:call) { described_class.call(params:) }

  let(:params) { { siren: } }
  let(:tabular_api_endpoint) do
    %r{#{Siade.credentials[:dgfip_tva_base_url]}/api/resources/.+/data/}
  end

  describe 'happy path' do
    let(:siren) { '217500016' }

    before do
      stub_request(:get, tabular_api_endpoint)
        .with(query: hash_including('vat_no__exact' => '72217500016'))
        .to_return(status: 200, body: {
          data: [{ vat_no: '72217500016' }],
          meta: { total: 1 }
        }.to_json)
      mock_dgfip_tva_refresh_date
    end

    it { is_expected.to be_a_success }

    it 'returns the TVA number for the SIREN' do
      expect(call.bundled_data.data.numero_tva).to eq('FR72217500016')
    end

    it 'exposes the dataset refresh date in the resource' do
      expect(call.bundled_data.data.date_derniere_mise_a_jour).to eq('2026-06-11T11:00:00+00:00')
    end
  end

  describe 'with no matching VAT number (TVA not in DGFIP extract)' do
    let(:siren) { '217500016' }

    before do
      stub_request(:get, tabular_api_endpoint)
        .to_return(status: 200, body: { data: [], meta: { total: 0 } }.to_json)
    end

    it { is_expected.to be_a_failure }
    its(:errors) { is_expected.to include(an_instance_of(NotFoundError)) }
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
