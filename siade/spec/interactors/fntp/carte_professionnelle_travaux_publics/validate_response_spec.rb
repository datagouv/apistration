RSpec.describe FNTP::CarteProfessionnelleTravauxPublics::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:) }

  context 'when it is a HTTP ok' do
    let(:response) { instance_double(Net::HTTPOK, code: '200') }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'when it is a not found response' do
    let(:response) { instance_double(Net::HTTPNotFound, code: '404') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'when it is an another response' do
    let(:response) { instance_double(Net::HTTPBadGateway, code: '502') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end

  context 'with a 500 code' do
    let(:response) { instance_double(Net::HTTPInternalServerError, code: '500') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
  end
end
