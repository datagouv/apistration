RSpec.describe CNETP::AttestationCotisationsCongesPayesChomageIntemperies::ValidateResponse, type: :validate_response do
  subject { described_class.call(response: response) }

  context 'when it is a HTTP OK' do
    let(:response) { instance_double(Net::HTTPOK, code: '200') }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'when it is a not found response' do
    let(:response) { instance_double(Net::HTTPNotFound, code: '404', body: '') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'when it is an another response' do
    let(:response) { instance_double(Net::HTTPBadGateway, code: '502', body: '') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
