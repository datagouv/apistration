RSpec.describe SIADE::V2::OAuth2::AbstractTokenProvider do
  subject { DummyTokenProvider.new }

  before(:all) do
    DummyTokenProvider = Class.new do
      include SIADE::V2::OAuth2::AbstractTokenProvider
      def client_get_token_params
        { params: :params }
      end

      def client_options
        {}
      end

      def access_token_options
        {}
      end

      def client_id
        :client_id
      end

      def client_secret
        :client_secret
      end
    end
  end

  let(:dummy_client) { double(:dummy_client) }
  let(:dummy_token) { OAuth2::AccessToken.from_hash(dummy_client, token_hash) }
  let(:access_token) { 'dummy_access_token' }

  let(:token_hash) do
    {
      grant_type: 'client_credentials',
      access_token:,
      expires_at: 10.seconds.since.to_i,
      token_type: 'Bearer'
    }
  end

  before do
    allow(dummy_client).to receive(:get_token).and_return(dummy_token)
    allow(OAuth2::Client).to receive(:new).and_return(dummy_client)
  end

  context 'when the token is not stored in cache' do
    its(:token) { is_expected.to eq access_token }

    it 'asks the provider for a new token' do
      expect(dummy_client)
        .to receive(:get_token)
        .with({ params: :params }, {})
      subject.token
    end

    it 'stores the new token json in cache' do
      expect {
        subject.token
      }.to change { EncryptedCache.read(:dummy) }.to(/#{access_token}/)
    end
  end

  context 'when the token is stored in cache' do
    let(:cached_access_token) { 'another_dummy_access_token' }
    let(:token_cached) do
      {
        expires_at: expires_at,
        token_type: 'Bearer',
        access_token: cached_access_token
      }
    end

    before do
      EncryptedCache.write(:dummy, token_cached.to_json)
    end

    context 'when the token in cache is not expired' do
      let(:expires_at) { 10.seconds.since.to_i }

      its(:token) { is_expected.to eq cached_access_token }

      it 'does not ask for a new token' do
        expect(dummy_client).not_to receive(:get_token)

        subject.token
      end

      it 'retrieves the token from cache' do
        expect(EncryptedCache).to receive(:read).with(:dummy)

        subject.token
      end
    end

    context 'when the token in cache is expired' do
      let(:expires_at) { 10.seconds.ago.to_i }

      its(:token) { is_expected.to eq access_token }

      it 'asks the provider for a new token' do
        expect(dummy_client)
          .to receive(:get_token)
          .with({ params: :params }, {})

        subject.token
      end

      it 'stores the new token json into cache' do
        expect {
          subject.token
        }.to change { EncryptedCache.read(:dummy) }.to(/#{access_token}/)
      end
    end
  end

  context 'when parsing stored token fails' do
    before do
      EncryptedCache.write(:dummy, 'not a valid JSON')
    end

    its(:token) { is_expected.to eq access_token }

    it 'gets a new token from provider' do
      expect(dummy_client)
        .to receive(:get_token)
        .with({ params: :params }, {})
      subject.token
    end

    it 'sends a message to Sentry' do
      expect(MonitoringService.instance)
        .to receive(:capture_message)
        .with(/Error while parsing DummyTokenProvider.*JSON::ParserError/, level: 'warning')

      subject.token
    end
  end

  context 'when provider returns an error' do
    before do
      allow(OAuth2::Client).to receive(:new).and_return(dummy_client)
      allow(dummy_client).to receive(:get_token).and_raise(error)
    end

    context 'when it is an oauth2 error' do
      let(:response_body_from_sentry) do
        {
          reasons: [{
            language: 'fr',
            message: 'Erreur technique'
          }],
          details: {
            msgId: 'Id-8b87ee5fc10471b6cacf9ad1'
          }
        }
      end

      let(:error) do
        OAuth2::Error.new(
          OAuth2::Response.new(
            Faraday::Response.new(
              response_headers: {},
              body: response_body_from_sentry.to_json
            )
          )
        )
      end

      it 'raises an error when retrieving the token' do
        expect { subject.token }.to raise_error(SIADE::V2::OAuth2::AbstractTokenProvider::Error)
      end

      it 'tracks error' do
        expect(MonitoringService.instance)
          .to receive(:track)
          .with(
            :warn,
            'Error while retrieving DummyTokenProvider OAuth2 JSON token from provider',
            {
              exception: {
                class: 'OAuth2::Error',
                message: response_body_from_sentry.to_json,
              }
            }
          )
        begin
          subject.token
        rescue SIADE::V2::OAuth2::AbstractTokenProvider::Error
        end
      end
    end

    context 'when it is a connection reset by peer error' do
      let(:error) { Errno::ECONNRESET }

      it 'raises an error when retrieving the token' do
        expect { subject.token }.to raise_error(SIADE::V2::OAuth2::AbstractTokenProvider::Error)
      end

      it 'tracks error' do
        expect(MonitoringService.instance)
          .to receive(:track)
          .with(
            :warn,
            'Error while retrieving DummyTokenProvider OAuth2 JSON token from provider',
            {
              exception: {
                class: 'Errno::ECONNRESET',
                message: 'Connection reset by peer'
              }
            }
          )
        begin
          subject.token
        rescue SIADE::V2::OAuth2::AbstractTokenProvider::Error
        end
      end
    end

    context 'when it is a net timeout error' do
      let(:error) { Net::OpenTimeout }

      it 'raises an error when retrieving the token' do
        expect { subject.token }.to raise_error(SIADE::V2::OAuth2::AbstractTokenProvider::Error)
      end

      it 'tracks error' do
        expect(MonitoringService.instance)
          .to receive(:track)
          .with(
            :warn,
            'Error while retrieving DummyTokenProvider OAuth2 JSON token from provider',
            {
              exception: {
                class: 'Net::OpenTimeout',
                message: 'Net::OpenTimeout'
              }
            }
          )
        begin
          subject.token
        rescue SIADE::V2::OAuth2::AbstractTokenProvider::Error
        end
      end
    end
  end
end
