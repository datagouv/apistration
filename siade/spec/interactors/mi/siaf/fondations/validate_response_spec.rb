RSpec.describe MI::SIAF::Fondations::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'SIAF') }

  let(:response) { instance_double(response_class, code:, body:, to_hash: {}) }

  context 'when the fondation is found' do
    let(:response_class) { Net::HTTPOK }
    let(:code) { '200' }
    let(:body) { read_payload_file('mi/siaf/fondations/valid.json') }

    it { is_expected.to be_a_success }
  end

  context 'when the fondation is unknown' do
    let(:response_class) { Net::HTTPNotFound }
    let(:code) { '404' }
    let(:body) { read_payload_file('mi/siaf/fondations/not_found.json') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'when the gateway rejects our token with a SOAP fault' do
    let(:response_class) { Net::HTTPUnauthorized }
    let(:code) { '401' }
    let(:body) { read_payload_file('mi/siaf/fondations/unauthorized.xml') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end

  context 'when the provider rate limits us' do
    let(:response_class) { Net::HTTPTooManyRequests }
    let(:code) { '429' }
    let(:body) { '' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderRateLimitingError)) }
  end

  context 'when the provider fails internally' do
    let(:response_class) { Net::HTTPInternalServerError }
    let(:code) { '500' }
    let(:body) { '' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
  end

  context 'when a 200 does not carry a fondation' do
    let(:response_class) { Net::HTTPOK }
    let(:code) { '200' }
    let(:body) { '[]' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
