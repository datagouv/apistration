RSpec.describe DGFIP::AttestationFiscale::ValidateResponse, type: :validate_response do
  subject { described_class.call(response: response, provider_name: 'DGFIP') }

  context 'with a http ok' do
    let(:response) { instance_double('Net::HTTPOK', code: '200', body: body) }

    context 'when body is a valid pdf' do
      let(:body) { File.read(Rails.root.join('spec/support/dgfip_attestations_fiscales/basic.pdf')) }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when body is not a pdf' do
      let(:body) { 'lol' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end
  end

  context 'with a not found response' do
    let(:response) { instance_double('Net::HTTPNotFound', code: '404') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'with an unknown error' do
    let(:response) { instance_double('Net::HTTPBadRequest', code: '400') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
