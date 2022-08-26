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
end
