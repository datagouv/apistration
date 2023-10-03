RSpec.describe CarifOref::CertificationsQualiopiFranceCompetences::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'CARIF-OREF') }

  context 'with a http ok' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }

    context 'when it is a valid payload' do
      let(:body) { read_payload_file('carif_oref/qualiopi/valid.json') }

      it { is_expected.to be_a_success }
      its(:errors) { is_expected.to be_empty }
    end

    context 'when it is an invalid payload' do
      let(:body) { read_payload_file('carif_oref/qualiopi/invalid.json') }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end

    context 'when it is not a valid json' do
      let(:body) { 'not a json' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end
  end

  context 'with a not found response' do
    let(:response) { instance_double(Net::HTTPNotFound, code: '404') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'with an unknown error' do
    let(:response) { instance_double(Net::HTTPBadRequest, code: '400') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
