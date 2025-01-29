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

      def extra_headers(request)
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

  let(:access_token) { 'dummy_client_token' }
  let(:expires_in) { '1660563182' }

  context 'when call works' do
    let!(:stubbed_request) do
      stub_request(:post, /dummy_client_uri/)
        .with(
          headers: { Authorization: 'Basic dummy_client_credentials' }
        )
        .to_return(body: response_body.to_json)
    end

    context 'when token is empty' do
      let(:access_token) { '' }

      it { is_expected.to be_a_failure }

      it 'adds ProviderUnknownError to errors' do
        expect(subject.errors).to include(instance_of(ProviderUnknownError))
      end
    end

    context 'when the token is not stored in cache' do
      it { is_expected.to be_a_success }
      its(:errors) { is_expected.to be_empty }

      its(:token) { is_expected.to eq access_token }

      it 'asks the provider for a new token' do
        make_call

        expect(stubbed_request).to have_been_requested
      end

      it 'stores the new token in cache' do
        expect {
          make_call
        }.to change { EncryptedCache.read(:dummy_token_authentication) }.to(access_token)
      end

      it 'stores the new token with expiration minus 10 seconds' do
        expect(EncryptedCache.instance).to receive(:write).with(
          anything,
          access_token,
          expires_in: expires_in.to_i - 10
        )

        make_call
      end
    end

    context 'when the token is already in cache' do
      before do
        EncryptedCache.write(:dummy_token_authentication, access_token)
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

  context 'when call failed because of a request fail' do
    before do
      stub_request(:post, /dummy_client_uri/).to_timeout
    end

    it { is_expected.to be_a_failure }

    it 'adds ProviderTimeoutError to errors' do
      expect(subject.errors).to include(instance_of(ProviderTimeoutError))
    end
  end
end
