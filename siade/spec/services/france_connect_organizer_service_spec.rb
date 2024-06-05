RSpec.describe FranceConnectOrganizerService do
  subject { described_class.new(token).fetch }

  let(:token) { 'token' }

  before do
    allow(MockDataBackend).to receive(:get_response_for).and_return(nil)
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
                payload: france_connect_v2_checktoken_payload.deep_stringify_keys
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
end
