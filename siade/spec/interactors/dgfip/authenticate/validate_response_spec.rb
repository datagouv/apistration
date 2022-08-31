RSpec.describe DGFIP::Authenticate::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:) }

  context 'with valid response', vcr: { cassette_name: 'dgfip/authenticate/valid' } do
    let(:response) { DGFIP::Authenticate::MakeRequest.call.response }

    it { is_expected.to be_a_success }
  end

  context 'when response renders invalid credentials' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body: 'Identifiant ou mot de passe erroné') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(ProviderAuthenticationError) }
  end

  context 'when cookie has an invalid format' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body: '', '[]': 'invalid') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(ProviderAuthenticationError) }
  end
end
