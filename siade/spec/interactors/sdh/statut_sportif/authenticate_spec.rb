RSpec.describe SDH::StatutSportif::Authenticate do
  subject(:interactor) { described_class.call }

  let!(:stubbed_request) do
    stub_request(:post, Siade.credentials[:sdh_authenticate_url]).with(
      body: {
        'client_id' => Siade.credentials[:sdh_client_id],
        'client_secret' => Siade.credentials[:sdh_client_secret],
        'grant_type' => 'client_credentials'
      }
    ).to_return(
      status: 200,
      body: '{"access_token": "test_access_token", "token_type": "Bearer"}'
    )
  end

  it { is_expected.to be_a_success }

  its(:token) { is_expected.to eq('test_access_token') }

  it 'calls the authentication endpoint with correct parameters' do
    interactor

    expect(stubbed_request).to have_been_requested
  end
end
