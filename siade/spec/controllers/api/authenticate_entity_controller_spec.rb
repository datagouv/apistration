RSpec.describe API::AuthenticateEntityController do
  controller(described_class) do
    skip_after_action :verify_authorized

    def index
      render json: {}, status: :ok
    end
  end

  context 'malformatted requests' do
    it 'returns 401 when token is missing' do
      get :index
      assert_response 401
    end

    it 'returns 401 with bad header naming' do
      request.headers['Authorization'] = "FuBearer #{yes_jwt}"
      get :index
      assert_response 401
    end
  end

  context 'with a jwt token' do
    context 'when jwt is passed in the header' do
      before { request.headers['Authorization'] = "Bearer #{token}" }

      context 'with a valid jwt' do
        let(:token) { yes_jwt }

        it 'returns 200' do
          get :index, params: mandatory_params
          assert_response 200
        end

        it 'does not logs unauthorized' do
          expect(UserAccessSpy).not_to receive(:log_unauthorized)
          get :index
        end
      end

      context 'with an expired jwt' do
        let(:token) { expired_jwt }

        let(:jwt_user) do
          ::JwtTokenService.new(jwt: expired_jwt).jwt_user
        end

        it 'logs unauthorized' do
          expect(UserAccessSpy).to receive(:log_expired_token).with(user: instance_of(jwt_user.class))

          get :index
          assert_response 401
          expect(response.body).to include('Votre token est expiré. Vous devez refaire une demande à API Entreprise,')
        end
      end

      context 'with an unsigned jwt' do
        let(:token) { unsigned_jwt }

        it 'logs unauthorized' do
          expect(UserAccessSpy).to receive(:log_unauthorized).with(user_info: token)

          get :index
          assert_response 401
        end
      end

      context 'with a invalid jwt' do
        let(:token) { forged_jwt }

        it 'logs unauthorized' do
          expect(UserAccessSpy).to receive(:log_unauthorized).with(user_info: token)

          get :index
          assert_response 401
        end
      end

      context 'with a incorrect jwt' do
        let(:token) { corrupted_jwt }

        it 'logs unauthorized' do
          expect(UserAccessSpy).to receive(:log_unauthorized).with(user_info: token)

          get :index
          assert_response 401
        end
      end
    end

    context 'when jwt is passed in the parameters' do
      context 'with a valid jwt' do
        let(:token) { yes_jwt }

        it 'does not logs unauthorized' do
          expect(UserAccessSpy).not_to receive(:log_unauthorized)

          get :index, params: { token: token }.merge(mandatory_params)
          assert_response 200
        end
      end

      context 'with an unsigned jwt' do
        let(:token) { unsigned_jwt }

        it 'logs unauthorized' do
          expect(UserAccessSpy).to receive(:log_unauthorized).with(user_info: token)

          get :index, params: { token: token }
          assert_response 401
        end
      end

      context 'with a invalid jwt' do
        let(:token) { forged_jwt }

        it 'logs unauthorized' do
          expect(UserAccessSpy).to receive(:log_unauthorized).with(user_info: token)
          get :index, params: { token: token }
          assert_response 401
        end
      end

      context 'with a incorrect jwt' do
        let(:token) { corrupted_jwt }

        it 'logs unauthorized' do
          expect(UserAccessSpy).to receive(:log_unauthorized).with(user_info: token)
          get :index, params: { token: token }
          assert_response 401
        end
      end
    end
  end

  describe 'monitoring service context setup' do
    let(:uuid_regex) { /\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/ }
    let(:date_regex) { /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}[+-]\d{2}:\d{2}/ }

    it 'sets user context with pundit user' do
      expect(MonitoringService.instance).to receive(:set_user_context).with({
        id: a_string_matching(uuid_regex),
        roles: an_instance_of(Array),
        jti: a_string_matching(uuid_regex),
        iat: a_string_matching(date_regex),
        exp: nil
      })

      get :index, params: { token: yes_jwt }
    end

    it 'sets expected params in context' do
      expect(MonitoringService.instance).to receive(:set_controller_params).with({
        context: 'API Entreprise TESTS',
        object: 'Testing things',
        recipient: 'SIADE Localhost',
        controller: 'api/authenticate_entity',
        action: 'index',
        token: yes_jwt
      })

      get :index, params: { token: yes_jwt }.merge(mandatory_params)
    end
  end

  context 'when in staging environement' do
    before do
      allow(Rails.env).to receive(:staging?).and_return(true)

      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(MockableInStaging)
        .to receive(:json)
        .and_return(dummy: 'example value')
      # rubocop:enable RSpec/AnyInstance
    end

    it 'checks mandatory params before trying to mock response' do
      get :index, params: { token: yes_jwt }
      assert_response 422
    end

    it 'renders an example instead of normal payload' do
      get :index, params: { token: yes_jwt }.merge(mandatory_params)
      expect(response_json).to eq(dummy: 'example value')
    end
  end
end
