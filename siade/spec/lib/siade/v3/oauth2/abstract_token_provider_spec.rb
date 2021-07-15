RSpec.describe SIADE::V3::OAuth2::AbstractTokenProvider do
  subject { DummyTokenProvider.new }

  before(:all) do
    DummyTokenProvider = Class.new do
      include SIADE::V3::OAuth2::AbstractTokenProvider
      def client_get_token_params; { params: :params }; end
      def client_options; {}; end
      def access_token_options; {}; end
      def client_id; :client_id; end
      def client_secret; :client_secret; end
    end
  end

  let(:dummy_client) { double(:dummy_client) }
  let(:dummy_token) { OAuth2::AccessToken.from_hash(dummy_client, token_hash) }
  let(:token_hash) do
    {
      grant_type:   'client_credentials',
      access_token: 'This is a dummy token from client',
      expires_at:   10.seconds.since.to_i,
      token_type:   'Bearer'
    }
  end

  before do
    allow(dummy_client).to receive(:get_token).and_return(dummy_token)
    allow(OAuth2::Client).to receive(:new).and_return(dummy_client)
  end

  context 'when the token is not stored in Redis' do
    its(:token) { is_expected.to eq 'This is a dummy token from client' }

    it 'asks the provider for a new token' do
      expect(dummy_client)
        .to receive(:get_token)
        .with({ params: :params }, {})
      subject.token
    end

    it 'stores the new token in Redis' do
      expect(Redis.current).to receive(:set).with(:dummy, /access_token.+dummy token from client/)
      subject.token
    end
  end

  context 'when the token is stored in Redis' do
    let(:token_redis) do
      {
        expires_at:   expires_at,
        token_type:   'Bearer',
        access_token: 'This is an access token from Redis'
      }
    end

    before do
      Redis.current.set(:dummy, token_redis.to_json)
    end

    context 'when the token in Redis is not expired' do
      let(:expires_at) { 10.seconds.since.to_i }

      its(:token) { is_expected.to eq 'This is an access token from Redis' }

      it 'does not ask for a new token' do
        expect(dummy_client).not_to receive(:get_token)
        subject.token
      end

      it 'retrieves the token from Redis' do
        expect(Redis.current).to receive(:get).with(:dummy)
        subject.token
      end
    end

    context 'when the token in Redis is expired' do
      let(:expires_at) { 10.seconds.ago.to_i }

      its(:token) { is_expected.to eq 'This is a dummy token from client' }

      it 'asks the provider for a new token' do
        expect(dummy_client)
          .to receive(:get_token)
          .with({ params: :params }, {})
        subject.token
      end

      it 'stores the new token into Redis' do
        expect(Redis.current).to receive(:set).with(:dummy, /access_token.+dummy token from client/)
        subject.token
      end
    end
  end

  context 'when parsing stored token fails' do
    before { Redis.current.set(:dummy, "not a valid JSON") }

    its(:token) { is_expected.to eq 'This is a dummy token from client' }

    it 'gets a new token from provider' do
      expect(dummy_client)
        .to receive(:get_token)
        .with({ params: :params }, {})
      subject.token
    end

    it 'sends a message to Sentry' do
      expect(MonitoringService.instance)
        .to receive(:capture_message)
        .with("Error while parsing DummyTokenProvider OAuth2 JSON token from Redis (JSON::ParserError 809: unexpected token at 'not a valid JSON')", level: 'warning')
      subject.token
    end
  end

  context 'when provider returns an error' do
    let(:response_body_from_sentry) do
      {
        reasons: [{
          language: "fr",
          message:  "Erreur technique"
        }],
        details: {
          msgId: "Id-8b87ee5fc10471b6cacf9ad1"
        }
      }
    end

    # rescue needs to match a TypeError instance that doubles are not
    # so we need a 'real' error and this one is quite anoying to create
    let(:oauth2_error) do
      OAuth2::Error.new(
        OAuth2::Response.new(
          Faraday::Response.new(
            response_headers: {},
            body:             response_body_from_sentry.to_json
          )
        )
      )
    end

    before do
      allow(OAuth2::Client).to receive(:new).and_return(dummy_client)
      allow(dummy_client).to receive(:get_token).and_raise(oauth2_error)
    end

    it 'raises an error when retrieving the token' do
      expect { subject.token }.to raise_error(SIADE::V3::OAuth2::AbstractTokenProvider::Error)
    end

    it 'sends a message to Sentry' do
      expect(MonitoringService.instance)
        .to receive(:capture_message)
        .with("Error while retrieving DummyTokenProvider OAuth2 JSON token from provider (OAuth2::Error #{response_body_from_sentry.to_json}))", level: 'warning')
      begin
        subject.token
      rescue SIADE::V3::OAuth2::AbstractTokenProvider::Error
      end
    end
  end
end
