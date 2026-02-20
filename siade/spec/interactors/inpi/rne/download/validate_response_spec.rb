RSpec.describe INPI::RNE::Download::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'INPI - RNE', params:, request_url:) }

  let(:params) { { document_id: 'some-uuid' } }
  let(:request_url) { 'https://inpi_rne_url.gouv.fr/api/actes/some-uuid/download' }

  context 'with a http ok' do
    let(:response) { instance_double(Net::HTTPOK, code: '200') }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'with a not found response' do
    let(:response) { instance_double(Net::HTTPNotFound, code: '404') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'with a 403 Cloudflare error' do
    let(:response) { instance_double(Net::HTTPForbidden, code: '403') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnavailable)) }

    it 'tracks warning with document_id' do
      expect(MonitoringService.instance).to receive(:track_with_added_context).with(
        'warning',
        'INPI RNE Download: Cloudflare 403',
        { document_id: 'some-uuid', url: 'https://inpi_rne_url.gouv.fr/api/actes/some-uuid/download' }
      )

      subject
    end
  end

  context 'with a 429 error' do
    let(:response) { instance_double(Net::HTTPTooManyRequests, code: '429') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderRateLimitingError)) }
  end

  context 'with an unknown error' do
    let(:response) { instance_double(Net::HTTPBadRequest, code: '400') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
