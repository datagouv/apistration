RSpec.describe GetOAuth2Token, type: :interactor do
  subject(:make_call) { DummyOAuthAuthentication.call }

  before(:all) do
    class DummyOAuthAuthentication < described_class
      def client_url
        'https://dummy_client_uri'
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

  before do
    stub_request(:post, /dummy_client_uri/)
      .with(
        body: 'client_id=dummy_client_id&client_secret=dummy_secret&grant_type=client_credentials&scope=dummy_scope'
      )
      .to_return(body: response_body.to_json)
  end

  it { is_expected.to be_a_success }
  its(:errors) { is_expected.to be_empty }

  its(:token) { is_expected.to eq access_token }

  context 'when provider returns HTML instead of JSON' do
    let(:created_instances) { [] }

    before do
      allow(DummyOAuthAuthentication).to receive(:new).and_wrap_original do |method, *args|
        method.call(*args).tap do |instance|
          allow(instance).to receive(:sleep)
          created_instances << instance
        end
      end

      stub_request(:post, /dummy_client_uri/)
        .to_return(status: 404, body: '<!DOCTYPE html><html><body>Not Found</body></html>')
    end

    it { is_expected.to be_a_failure }

    it 'retries authentication 5 times before giving up' do
      make_call

      expect(WebMock).to have_requested(:post, /dummy_client_uri/).times(5)
    end

    it 'sleeps between auth retries' do
      make_call

      expect(created_instances.last).to have_received(:sleep).with(AbstractGetToken::AUTH_RETRY_DELAY).exactly(4).times
    end

    it 'adds a ProviderUnknownError' do
      expect(make_call.errors).to include(instance_of(ProviderUnknownError))
    end
  end

  context 'when provider returns HTML then recovers' do
    let(:created_instances) { [] }

    before do
      allow(DummyOAuthAuthentication).to receive(:new).and_wrap_original do |method, *args|
        method.call(*args).tap do |instance|
          allow(instance).to receive(:sleep)
          created_instances << instance
        end
      end

      stub_request(:post, /dummy_client_uri/)
        .to_return(
          { status: 404, body: '<!DOCTYPE html><html><body>Not Found</body></html>' },
          { status: 404, body: '<!DOCTYPE html><html><body>Not Found</body></html>' },
          { status: 200, body: response_body.to_json }
        )
    end

    it { is_expected.to be_a_success }

    its(:token) { is_expected.to eq access_token }

    it 'retries until success' do
      make_call

      expect(WebMock).to have_requested(:post, /dummy_client_uri/).times(3)
    end

    it 'sleeps between failed attempts' do
      make_call

      expect(created_instances.last).to have_received(:sleep).with(AbstractGetToken::AUTH_RETRY_DELAY).twice
    end
  end
end
