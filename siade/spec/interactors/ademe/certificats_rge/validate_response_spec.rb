RSpec.describe ADEME::CertificatsRGE::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'ADEME') }

  context 'with a http ok' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }

    context 'with results' do
      let(:body) do
        {
          total: 1,
          results: [{ siret: '50530961700023' }]
        }.to_json
      end

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'with no results' do
      let(:body) do
        {
          total: 0,
          results: []
        }.to_json
      end

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end
  end

  context 'with an unknown error' do
    let(:response) { instance_double(Net::HTTPBadRequest, code: '400') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
