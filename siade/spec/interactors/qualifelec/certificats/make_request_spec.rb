RSpec.describe Qualifelec::Certificats::MakeRequest, type: :make_request do
  describe '.call' do
    subject(:make_call) { described_class.call(params:, token:) }

    let(:siret) { valid_siret(:qualifelec) }
    let(:params) do
      {
        siret:
      }
    end

    let(:token) { 'SUPER TOKEN' }

    let!(:stubbed_request) do
      stub_qualifelec_certificates
    end

    it_behaves_like 'a make request with working mocking_params'

    context 'with a valid siret' do
      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }

      it 'calls url with valid body, which interpolates params' do
        make_call

        expect(stubbed_request).to have_been_requested
      end
    end
  end
end
