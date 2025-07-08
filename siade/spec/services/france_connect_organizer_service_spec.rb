RSpec.describe FranceConnectOrganizerService do
  subject { described_class.new(token, api_name, api_version).fetch }

  let(:token) { 'token' }
  let(:api_name) { 'whatever' }
  let(:api_version) { '2' }

  before do
    allow(MockDataBackend).to receive(:get_response_for).and_return(nil)
    allow(Siade.credentials).to receive(:[]).and_call_original
    allow(Siade.credentials).to receive(:[]).with(:france_connect_v2_whatever_client_id).and_return('345')
    allow(Siade.credentials).to receive(:[]).with(:france_connect_v2_whatever_client_secret).and_return('345')
    allow(Siade.credentials).to receive(:[]).with(:france_connect_v2_enabled).and_return(true)
  end

  describe 'when using france connect v2' do
    before do
      mock_invalid_france_connect_v1_checktoken
    end

    describe 'in staging' do
      before do
        allow(Rails.env).to receive(:staging?).and_return(true)
      end

      context 'when token renders a payload in MockDataBackend' do
        before do
          allow(MockDataBackend).to receive(:get_response_for)
            .with('france_connect_v2', { token: })
            .and_return(
              {
                status: '200',
                payload: france_connect_v2_decrypted_payload.deep_stringify_keys
              }
            )
        end

        it { is_expected.to be_a_success }

        its(:service_user_identity) { is_expected.to be_a(Resource) }
        its(:user) { is_expected.to be_a(JwtUser) }
      end

      context 'when token does not render a payload in MockDataBackend' do
        before do
          allow(MockDataBackend).to receive(:get_response_for)
            .with('france_connect_v2', { token: })
            .and_return(nil)
        end

        context 'when token is valid' do
          before do
            mock_valid_france_connect_v2_checktoken
          end

          it { is_expected.to be_a_success }

          its(:service_user_identity) { is_expected.to be_a(Resource) }
          its(:user) { is_expected.to be_a(JwtUser) }
        end

        context 'when token is invalid' do
          before do
            mock_invalid_france_connect_v2_checktoken
            mock_invalid_france_connect_v1_checktoken
          end

          it { is_expected.to be_a_failure }

          its(:errors) { is_expected.to include(instance_of(InvalidFranceConnectAccessTokenError)) }
        end
      end
    end

    context 'with valid token' do
      before do
        mock_valid_france_connect_v2_checktoken
      end

      it { is_expected.to be_a_success }

      its(:service_user_identity) { is_expected.to be_a(Resource) }
      its(:user) { is_expected.to be_a(JwtUser) }
    end

    context 'with invalid token' do
      before do
        mock_invalid_france_connect_v2_checktoken(kind)
      end

      context 'when it is expired or not found' do
        let(:kind) { :expired_or_not_found }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(InvalidFranceConnectAccessTokenError)) }
      end

      context 'when it is malformed' do
        let(:kind) { :malformed }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(InvalidFranceConnectAccessTokenError)) }
      end
    end
  end

  describe 'when using france connect v1' do
    before do
      mock_invalid_france_connect_v2_checktoken
    end

    describe 'in staging' do
      before do
        allow(Rails.env).to receive(:staging?).and_return(true)
      end

      context 'when token renders a payload in MockDataBackend' do
        before do
          allow(MockDataBackend).to receive(:get_response_for)
            .with('france_connect', { token: })
            .and_return(
              {
                status: '200',
                payload: france_connect_v1_checktoken_payload(scopes: minimal_france_connect_v1_scopes).stringify_keys
              }
            )
        end

        it { is_expected.to be_a_success }

        its(:service_user_identity) { is_expected.to be_a(Resource) }
        its(:client_attributes) { is_expected.to be_a(Resource) }
        its(:user) { is_expected.to be_a(JwtUser) }
      end

      context 'when token does not render a payload in MockDataBackend' do
        context 'when token is valid' do
          before do
            mock_valid_france_connect_v1_checktoken
          end

          it { is_expected.to be_a_success }

          its(:service_user_identity) { is_expected.to be_a(Resource) }
          its(:client_attributes) { is_expected.to be_a(Resource) }
          its(:user) { is_expected.to be_a(JwtUser) }
        end

        context 'when token is invalid' do
          before do
            mock_invalid_france_connect_v1_checktoken
          end

          it { is_expected.to be_a_failure }

          its(:errors) { is_expected.to include(instance_of(InvalidFranceConnectAccessTokenError)) }
        end
      end
    end

    context 'with valid token' do
      before do
        mock_valid_france_connect_v1_checktoken
      end

      it { is_expected.to be_a_success }

      its(:service_user_identity) { is_expected.to be_a(Resource) }
      its(:client_attributes) { is_expected.to be_a(Resource) }
      its(:user) { is_expected.to be_a(JwtUser) }
    end

    context 'with invalid token' do
      before do
        mock_invalid_france_connect_v1_checktoken(kind)
      end

      context 'when it is expired or not found' do
        let(:kind) { :expired_or_not_found }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(InvalidFranceConnectAccessTokenError)) }
      end

      context 'when it is malformed' do
        let(:kind) { :malformed }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(InvalidFranceConnectAccessTokenError)) }
      end
    end
  end

  describe 'when feature flag is disabled' do
    before do
      mock_valid_france_connect_v1_checktoken
      mock_valid_france_connect_v2_checktoken

      allow(Siade.credentials).to receive(:[]).with(:france_connect_v2_enabled).and_return(false)

      allow(FranceConnect::V2::DataFetcherThroughAccessToken).to receive(:call)
      allow(FranceConnect::V1::DataFetcherThroughAccessToken).to receive(:call)
    end

    it 'does not call v2 and calls v1' do
      subject

      expect(FranceConnect::V2::DataFetcherThroughAccessToken).not_to have_received(:call)
      expect(FranceConnect::V1::DataFetcherThroughAccessToken).to have_received(:call)
    end
  end

  describe 'when feature flag is enabled' do
    before do
      mock_valid_france_connect_v1_checktoken
      mock_valid_france_connect_v2_checktoken

      allow(FranceConnect::V2::DataFetcherThroughAccessToken).to receive(:call).and_call_original
      allow(FranceConnect::V1::DataFetcherThroughAccessToken).to receive(:call)
    end

    it 'does not call v2 and calls v1' do
      subject

      expect(FranceConnect::V2::DataFetcherThroughAccessToken).to have_received(:call)
      expect(FranceConnect::V1::DataFetcherThroughAccessToken).not_to have_received(:call)
    end
  end
end
