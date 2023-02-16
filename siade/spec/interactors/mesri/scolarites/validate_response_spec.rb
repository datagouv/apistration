RSpec.describe MESRI::Scolarites::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'MESRI') }

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

  context 'with a provider internal server error response' do
    let(:response) { instance_double(Net::HTTPInternalServerError, code: '500') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
  end

  context 'with an unknown error' do
    let(:response) { instance_double(Net::HTTPUnknownResponse, code: '506') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
