RSpec.describe EuropeanCommission::VIES::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'Commission Européenne') }

  context 'with a http ok' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }

    context 'when body is a found payload' do
      let(:body) { read_payload_file('vies/valid.json') }

      it { is_expected.to be_a_success }

      its(:cacheable) { is_expected.to be(true) }
      its(:errors) { is_expected.to be_empty }
    end

    context 'when body is a not found payload' do
      let(:body) { read_payload_file('vies/invalid.json') }

      it { is_expected.to be_a_failure }

      its(:cacheable) { is_expected.to be(true) }
      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end

    context 'when body is a max concurrent req error' do
      let(:body) { read_payload_file('vies/max_concurrent_error.json') }

      it { is_expected.to be_a_failure }

      its(:cacheable) { is_expected.to be(false) }
      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end

    context 'when body is an ip banned error' do
      let(:body) { read_payload_file('vies/ip_blocked.json') }

      it { is_expected.to be_a_failure }

      its(:cacheable) { is_expected.to be(false) }
      its(:errors) { is_expected.to include(instance_of(ProviderRateLimitingError)) }
    end

    context 'when body is an unavailable payload' do
      let(:body) { read_payload_file('vies/unavailable.json') }

      it { is_expected.to be_a_failure }

      its(:cacheable) { is_expected.to be(false) }
      its(:errors) { is_expected.to include(instance_of(ProviderUnavailable)) }
    end

    context 'when body is a not valid' do
      let(:body) { 'whatever' }

      it { is_expected.to be_a_failure }

      its(:cacheable) { is_expected.to be(false) }
      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end
  end

  context 'with an unknown error' do
    let(:response) { instance_double(Net::HTTPBadRequest, code: '400') }

    it { is_expected.to be_a_failure }

    its(:cacheable) { is_expected.to be(false) }
    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
