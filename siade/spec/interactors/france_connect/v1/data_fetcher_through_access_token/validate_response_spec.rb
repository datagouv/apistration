RSpec.describe FranceConnect::V1::DataFetcherThroughAccessToken::ValidateResponse, type: :validate_response do
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
            status: 'fail',
            message: 'Malformed access token.'
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
            status: 'fail',
            message: 'token_not_found_or_expired'
          }.to_json
        end

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(InvalidFranceConnectAccessTokenError)) }
      end

      context 'when error is unknown' do
        let(:body) do
          {
            status: 'fail',
            message: 'lol'
          }.to_json
        end

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
      end
    end

    context 'with a 200 code and payload' do
      let(:code) { '200' }

      let(:body) { france_connect_v1_checktoken_payload(scopes:).to_json }

      context 'when scope includes identite_pivot nor profile or birth' do
        let(:scopes) { %w[openid identite_pivot] }

        it { is_expected.to be_a_success }

        its(:errors) { is_expected.to be_empty }
      end

      context 'when scope includes profile and birth (which is the same as identite_pivot)' do
        let(:scopes) { %w[openid birth profile] }

        it { is_expected.to be_a_success }

        its(:errors) { is_expected.to be_empty }
      end

      context 'when scope includes combinaisons of scopes which build the pivot identity' do
        let(:scopes) do
          %w[
            openid
            profile
            birthplace
            birthcountry
          ]
        end

        it { is_expected.to be_a_success }

        its(:errors) { is_expected.to be_empty }
      end

      context 'when scope does not include valid scope to build pivot identity' do
        let(:scopes) { %w[openid profile] }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(InvalidFranceConnectAccessTokenError)) }
      end

      context 'when FranceConnect token has wrong params' do
        let(:body) { france_connect_v1_checktoken_payload(scopes:).tap { |h| h[:identity].delete(:given_name) }.to_json }
        let(:scopes) { %w[openid birth profile] }

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
