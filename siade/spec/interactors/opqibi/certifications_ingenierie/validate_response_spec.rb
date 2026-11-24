RSpec.describe OPQIBI::CertificationsIngenierie::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'OPQIBI') }

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

  context 'when OPQIBI answers a 500 with an HTML page' do
    let(:response) { instance_double(Net::HTTPInternalServerError, code: '500', body: '<html><title>500 Internal Server Error</title></html>') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
  end

  context 'with an unknown error' do
    let(:response) { instance_double(Net::HTTPBadRequest, code: '400') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
