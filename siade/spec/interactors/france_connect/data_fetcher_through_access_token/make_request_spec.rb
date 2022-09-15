RSpec.describe FranceConnect::DataFetcherThroughAccessToken::MakeRequest, type: :make_request do
  subject(:make_call) { described_class.call(params:) }

  let(:params) do
    {
      token:
    }
  end

  let(:token) { 'token' }

  let!(:stubbed_request) do
    stub_request(:post, Siade.credentials[:france_connect_sandbox_check_token_url]).with(
      body: {
        token:
      }.to_json
    ).to_return(
      status: 200,
      body: france_connect_checktoken_payload.to_json
    )
  end

  it { is_expected.to be_a_success }

  its(:response) { is_expected.to be_a(Net::HTTPOK) }

  it 'calls url with valid params' do
    make_call

    expect(stubbed_request).to have_been_requested
  end
end
