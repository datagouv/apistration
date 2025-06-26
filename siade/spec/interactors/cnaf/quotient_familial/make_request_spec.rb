RSpec.describe CNAF::QuotientFamilial::MakeRequest, type: :make_request do
  subject(:make_call) { described_class.call(params:) }

  let(:params) do
    {
      postal_code:,
      beneficiary_number:
    }
  end

  let(:postal_code) { '75001' }
  let(:beneficiary_number) { '1234567' }

  let!(:stubbed_request) do
    stub_request(:post, Siade.credentials[:cnaf_quotient_familial_url]).with(
      body: %r{<matricule>#{beneficiary_number}</matricule>.*<codePostal>#{postal_code}</codePostal>}m
    ).to_return(
      status: 200,
      body: read_payload_file('cnaf/quotient_familial_valid_response.mime')
    )
  end

  before do
    stub_cnaf_quotient_familial_make_request_ssl_config
  end

  it_behaves_like 'a make request with working mocking_params'

  it { is_expected.to be_a_success }

  its(:response) { is_expected.to be_a(Net::HTTPOK) }

  it 'calls url with valid body, which interpolates params' do
    make_call

    expect(stubbed_request).to have_been_requested
  end
end
