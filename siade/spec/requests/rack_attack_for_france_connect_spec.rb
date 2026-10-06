RSpec.describe 'Rack::Attack config for FranceConnect endpoints', api: :particulier do
  include ActiveSupport::Testing::TimeHelpers

  let(:france_connect_check_token_url) { Siade.credentials[:france_connect_v2_check_token_url] }

  before do
    freeze_time
    mock_invalid_france_connect_checktoken
  end

  after { Rack::Attack.reset! }

  def call_with_random_bearer(remote_addr: '1.2.3.4')
    get '/v3/dss/quotient_familial/france_connect',
      params: { recipient: valid_siret(:recipient) },
      headers: { 'Authorization' => "Bearer #{SecureRandom.hex}", 'REMOTE_ADDR' => remote_addr }
  end

  describe 'FranceConnect introspection per IP and per minute' do
    it 'throttles random bearer tokens sent from the same IP' do
      31.times { call_with_random_bearer }

      expect(response).to have_http_status(:too_many_requests)
      expect(response.request.env['rack.attack.matched']).to eq('FranceConnect introspection per IP and per minute')
      expect(a_request(:post, france_connect_check_token_url)).to have_been_made.times(30)
    end

    it 'does not throttle another IP' do
      30.times { call_with_random_bearer }

      call_with_random_bearer(remote_addr: '5.6.7.8')

      expect(response).not_to have_http_status(:too_many_requests)
    end
  end

  describe 'FranceConnect introspection per IP and per hour' do
    it 'throttles random bearer tokens sent from the same IP over an hour' do
      travel_to Time.current.beginning_of_hour

      20.times do
        30.times { call_with_random_bearer }
        travel 1.minute
      end

      call_with_random_bearer

      expect(response).to have_http_status(:too_many_requests)
      expect(response.request.env['rack.attack.matched']).to eq('FranceConnect introspection per IP and per hour')
    end
  end
end
