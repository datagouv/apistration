RSpec.describe SDH::StatutSportif::MakeRequest, type: :make_request do
  subject { described_class.call(params:, token:) }

  let(:params) do
    {
      identifiant: '123456789'
    }
  end

  let(:token) { 'test_access_token' }

  let!(:stubbed_request) do
    stub_request(:get, "#{Siade.credentials[:sdh_endpoint_url]}/v1/statut-sportif/123456789").with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization' => 'Bearer test_access_token',
        'Host' => 'welovesports.gouv.fr',
        'User-Agent' => 'Ruby'
      }
    ).to_return(
      status: 200,
      body: '{"success": true}'
    )
  end

  it { is_expected.to be_a_success }

  it 'calls url with correct identifiant and headers' do
    subject

    expect(stubbed_request).to have_been_requested
  end
end
