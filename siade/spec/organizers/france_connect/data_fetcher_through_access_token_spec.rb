RSpec.describe FranceConnect::DataFetcherThroughAccessToken, type: :retriever_organizer do
  subject { described_class.call(params: { token: }) }

  let(:token) { 'token' }

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
