RSpec.describe AbstractGetToken, type: :interactor do
  subject(:make_call) { DummyTokenAuthentication.call }

  before(:all) do
    class DummyTokenAuthentication < described_class
      def client_url
        'https://dummy_client_uri'
      end

      def scope
        'dummy_scope'
      end

      def set_headers(request)
        request['Authorization'] = 'Basic dummy_client_credentials'
      end

      def access_token(response)
        JSON.parse(response.body)['access_token']
      end

      def expires_in(response)
        JSON.parse(response.body)['expires_in']
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
        headers: { Authorization: 'Basic dummy_client_credentials' }
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
      allow(RedisService.instance).to receive(:get).and_return(nil, 'a token that was just stored')
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
