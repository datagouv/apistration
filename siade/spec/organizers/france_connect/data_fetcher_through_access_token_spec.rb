RSpec.describe FranceConnect::DataFetcherThroughAccessToken, type: :retriever_organizer do
  subject { described_class.call(params: { token: }) }

  let(:token) { 'token' }

  describe 'in staging' do
    before do
      allow(Rails.env).to receive(:staging?).and_return(true)
    end

    context 'when token renders a payload in MockDataBackend' do
      before do
        allow(MockDataBackend).to receive(:get_response_for).and_return(
          {
            status: '200',
            payload: france_connect_checktoken_payload(scopes: minimal_france_connect_scopes).stringify_keys
          }
        )
      end

      it { is_expected.to be_a_success }

      its(:service_user_identity) { is_expected.to be_a(Resource) }
      its(:user) { is_expected.to be_a(JwtUser) }
    end

    context 'when token does not render a payload in MockDataBackend' do
      before do
        allow(MockDataBackend).to receive(:get_response_for).and_return(nil)
      end

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(InvalidFranceConnectAccessTokenError)) }
    end
  end

  context 'with valid token' do
    before do
      mock_valid_france_connect_checktoken
    end

    it { is_expected.to be_a_success }

    its(:service_user_identity) { is_expected.to be_a(Resource) }
    its(:user) { is_expected.to be_a(JwtUser) }
  end

  context 'with invalid token' do
    before do
      mock_invalid_france_connect_checktoken
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(InvalidFranceConnectAccessTokenError)) }
  end
end
