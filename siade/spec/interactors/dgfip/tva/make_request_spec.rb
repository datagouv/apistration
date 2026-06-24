RSpec.describe DGFIP::TVA::MakeRequest, type: :make_request do
  describe '.call' do
    subject(:make_call) { described_class.call(params:, tva_number:) }

    let(:params) { { siren: '217500016' } }
    let(:tva_number) { 'FR72217500016' }
    let!(:stubbed_request) do
      stub_request(:get, "#{DGFIP::TVA::MakeRequest::BASE_URL}/api/resources/#{DGFIP::TVA::MakeRequest::RESOURCE_ID}/data/")
        .with(query: { 'vat_no__exact' => '72217500016' })
        .to_return(status: 200, body: { data: [{ vat_no: '72217500016' }], meta: { total: 1 } }.to_json)
    end

    it_behaves_like 'a make request with working mocking_params'

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }

    it 'calls the tabular API with the exact TVA number' do
      make_call

      expect(stubbed_request).to have_been_requested
    end
  end
end
