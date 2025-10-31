RSpec.describe FranceConnect::DataFetcherThroughAccessToken::ValidateResponse, type: :validate_response do
  describe '.call' do
    subject(:call) { described_class.call(response:, provider_name: 'FranceConnect') }

    let(:response) do
      instance_double(Net::HTTPOK, code:, body:)
    end

    context 'with an invalid code' do
      let(:code) { '500' }
      let(:body) { 'whatever' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end

    context 'with a 400 code' do
      let(:code) { '400' }

      context 'when error said token is malformed' do
        let(:body) do
          {
            error: 'invalid_request',
            error_message: 'Required parameter missing or invalid.'
          }.to_json
        end

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(InvalidFranceConnectAccessTokenError)) }
      end
    end

    context 'with a 401 code' do
      let(:code) { '401' }

      context 'when error said token is not found or expired' do
        let(:body) do
          {
            error: 'invalid_client',
            error_message: 'Client authentication failed.'
          }.to_json
        end

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(InvalidFranceConnectAccessTokenError)) }
      end

      context 'when error is unknown' do
        let(:body) do
          {
            error: 'lol',
            error_message: 'ke passo ?'
          }.to_json
        end

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
      end
    end

    context 'with a 200 code and payload' do
      let(:code) { '200' }

      context 'when the token is valid' do
        let(:body) { france_connect_checktoken_payload(scopes:) }
        let(:scopes) { 'openid' }

        it { is_expected.to be_a_success }

        its(:errors) { is_expected.to be_empty }
      end

      context 'when the token is expired' do
        let(:body) { france_connect_checktoken_invalid_payload }
        let(:scopes) { 'openid' }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(InvalidFranceConnectAccessTokenError)) }
      end

      context 'when FranceConnect token has wrong params' do
        let(:body) { france_connect_checktoken_invalid_parameter_payload }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }

        it 'tracks errors' do
          expect(MonitoringService.instance).to receive(:track)

          subject
        end
      end
    end
  end
end
