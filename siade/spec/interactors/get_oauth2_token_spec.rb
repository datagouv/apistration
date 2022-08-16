RSpec.describe GetOAuth2Token, type: :interactor do
  subject(:make_call) { DummyTokenAuthentication.call }

  before(:all) do
    class DummyTokenAuthentication < GetOAuth2Token
      def client_url
        'https://dummy_client_uri'
      end

      def headers
        {
          Authorization: 'Basic dummy_client_credentials'
        }
      end

      def client_id
        'dummy_client_id'
      end

      def client_secret
        'dummy_secret'
      end

      def scope
        'dummy_scope'
      end
    end
  end

  let(:dummy_client) { instance_double(Net::HTTP) }

  let(:response_body) do
    {
      access_token:,
      expires_in: '1660563182'
    }
  end

  let(:access_token) { 'This is a dummy token from client' }
  let(:expires_in) { '1660563182' }

  let!(:stubbed_request) do
    stub_request(:post, /dummy_client_uri/)
      .with(
        headers: { Authorization: 'Basic dummy_client_credentials' },
        body: 'client_id=dummy_client_id&client_secret=dummy_secret&grant_type=client_credentials&scope=dummy_scope'
      )
      .to_return(body: response_body.to_json)
  end

  context 'when the token is not stored in Redis' do
    it { is_expected.to be_a_success }
    its(:errors) { is_expected.to be_empty }

    its(:token) { is_expected.to eq access_token }

    it 'asks the provider for a new token' do
      make_call

      expect(stubbed_request).to have_been_requested
    end

    it 'stores the new token in Redis' do
      expect(RedisService.instance).to receive(:set).with(:dummy_token_authentication, /This is a dummy token from client/, { ex: expires_in })

      make_call
    end
  end

  context 'when the token is stored in Redis' do
    before do
      RedisService.instance.set(:dummy_token_authentication, access_token, ex: expires_in)
    end

    it { is_expected.to be_a_success }
    its(:errors) { is_expected.to be_empty }

    its(:token) { is_expected.to eq access_token }

    it 'does not ask for a new token' do
      make_call

      expect(stubbed_request).not_to have_been_requested
    end
  end
end
