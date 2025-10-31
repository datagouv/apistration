RSpec.describe FranceConnect::DataFetcherThroughAccessToken, type: :retriever_organizer do
  subject { described_class.call(params: { token:, api_name:, api_version: }) }

  let(:token) { 'token' }
  let(:api_name) { 'quotient_familial' }
  let(:api_version) { '2' }

  describe 'in staging' do
    before do
      allow(Rails.env).to receive(:staging?).and_return(true)
    end

    context 'when token renders a payload in MockDataBackend' do
      before do
        allow(MockDataBackend).to receive(:get_response_for).and_return(
          {
            status: '200',
            payload: france_connect_decrypted_payload.deep_stringify_keys
          }
        )
      end

      it { is_expected.to be_a_success }

      its(:service_user_identity) { is_expected.to be_a(Resource) }
      its(:client_attributes) { is_expected.to be_a(Resource) }
      its(:user) { is_expected.to be_a(JwtUser) }
    end

    context 'when token does not render a payload in MockDataBackend' do
      before do
        allow(MockDataBackend).to receive(:get_response_for).and_return(nil)
      end

      context 'when token is valid' do
        before do
          mock_valid_france_connect_checktoken
        end

        it { is_expected.to be_a_success }

        its(:service_user_identity) { is_expected.to be_a(Resource) }
        its(:client_attributes) { is_expected.to be_a(Resource) }
        its(:user) { is_expected.to be_a(JwtUser) }
      end

      context 'when token is invalid' do
        before do
          mock_invalid_france_connect_checktoken
        end

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(InvalidFranceConnectAccessTokenError)) }
      end
    end
  end

  context 'with valid token' do
    before do
      mock_valid_france_connect_checktoken(scopes:)
    end

    let(:scopes) { "#{minimal_france_connect_scopes} api_name_identite" }

    it { is_expected.to be_a_success }

    its(:service_user_identity) { is_expected.to be_a(Resource) }
    its(:client_attributes) { is_expected.to be_a(Resource) }
    its(:user) { is_expected.to be_a(JwtUser) }

    context 'when api_version is 2' do
      it 'return all the scopes' do
        expect(subject.user.scopes).to eq(scopes.split)
      end
    end

    context 'when api_version 3 or more' do
      let(:api_version) { '42' }

      it 'removes the identity scopes' do
        expect(subject.user.scopes).to eq(minimal_france_connect_scopes.split)
      end
    end
  end

  context 'with invalid token' do
    before do
      mock_invalid_france_connect_checktoken(kind)
    end

    context 'when it is expired or not found' do
      let(:kind) { :expired_or_not_found }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(InvalidFranceConnectAccessTokenError)) }

      it 'tracks the error on MonitoringService' do
        expect(MonitoringService.instance).to receive(:track_with_added_context).with(
          'error',
          'FranceConnect error',
          {
            error: InvalidFranceConnectAccessTokenError.new(:not_found_or_expired).to_h
          }
        )

        subject
      end
    end

    context 'when it is malformed' do
      let(:kind) { :malformed }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(InvalidFranceConnectAccessTokenError)) }
    end
  end
end
