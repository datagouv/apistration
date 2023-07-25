RSpec.describe INPI::RNE::MakeRequest, type: :make_request do
  subject(:make_call) { described_class.call(token:, params:) }

  let(:token) { 'token' }
  let(:siren) { valid_siren }
  let(:params) do
    {
      siren:
    }
  end

  let!(:stubbed_request) do
    stub_request(:get, "#{Siade.credentials[:inpi_rne_unites_legales_url]}/#{siren}").with(
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{token}"
      }
    ).to_return(
      status: 200
    )
  end

  context 'when performing a request' do
    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }

    it 'calls url with valid body, which interpolates params' do
      make_call

      expect(stubbed_request).to have_been_requested
    end
  end
end
