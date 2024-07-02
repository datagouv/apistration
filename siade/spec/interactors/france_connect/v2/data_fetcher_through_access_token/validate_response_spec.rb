RSpec.describe FranceConnect::V2::DataFetcherThroughAccessToken::ValidateResponse, type: :validate_response do
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

      let(:body) { france_connect_v2_checktoken_payload(scopes:) }

      context 'when scope includes identite_pivot nor profile or birth' do
        let(:scopes) { 'openid identite_pivot' }

        it { is_expected.to be_a_success }

        its(:errors) { is_expected.to be_empty }
      end

      context 'when scope includes profile and birth (which is the same as identite_pivot)' do
        let(:scopes) { 'openid birth profile' }

        it { is_expected.to be_a_success }

        its(:errors) { is_expected.to be_empty }
      end

      context 'when scope includes combinaisons of scopes which build the pivot identity' do
        let(:scopes) do
          'openid profile birthplace birthcountry'
        end

        it { is_expected.to be_a_success }

        its(:errors) { is_expected.to be_empty }
      end

      context 'when scope does not include valid scope to build pivot identity' do
        let(:scopes) { %w[openid profile] }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(InvalidFranceConnectAccessTokenError)) }
      end
    end
  end
end
