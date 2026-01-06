class APIParticulier::V2::DummyController < APIParticulier::V2::BaseController; end

class APIParticulier::V2::DummyFranceConnectedController < APIParticulier::V2::BaseController
  include APIParticulier::FranceConnectable
end

class APIEntreprise::V3AndMore::DummyController < APIController; end

# rubocop:disable Lint/NestedMethodDefinition
def define_dummy_controller(controller_klass)
  controller(controller_klass) do
    def index
      head :ok
    end
  end
end

# rubocop:enable Lint/NestedMethodDefinition

RSpec.describe 'logstasher custom fields', type: :controller do
  subject(:make_call) do
    get :index, params: { api_version: '42' }
  end

  before do
    allow(LogStasher).to receive(:build_logstash_event)
  end

  define_dummy_controller(APIController)

  describe 'basic controller' do
    before do
      routes.draw { get 'index' => 'api#index' }
    end

    it 'adds basic custom fields to logstasher' do
      expect(LogStasher).to receive(:build_logstash_event).with(
        hash_including(
          type: 'siade',
          domain: 'test.host',
          user_agent_raw: 'Rails Testing',
          should_be_stored_in_database: true
        ),
        anything
      )

      make_call
    end

    it 'does not add api_version to logstasher' do
      expect(LogStasher).not_to receive(:build_logstash_event).with(
        hash_including(
          api_version: anything
        ),
        anything
      )

      make_call
    end
  end

  describe 'add_should_be_stored_in_database_flag behavior' do
    context 'when controller is in CONTROLLER_NOT_TO_STORE_IN_DATABASE list' do
      before do
        routes.draw { get 'index' => 'ping#index' }
      end

      define_dummy_controller(PingController)

      it 'sets should_be_stored_in_database to false' do
        expect(LogStasher).to receive(:build_logstash_event).with(
          hash_including(
            should_be_stored_in_database: false
          ),
          anything
        )

        make_call
      end
    end

    context 'when controller is not in CONTROLLER_NOT_TO_STORE_IN_DATABASE list' do
      before do
        routes.draw { get 'index' => 'api#index' }
      end

      it 'sets should_be_stored_in_database to true' do
        expect(LogStasher).to receive(:build_logstash_event).with(
          hash_including(
            should_be_stored_in_database: true
          ),
          anything
        )

        make_call
      end
    end
  end

  describe 'on api particulier request' do
    before do
      routes.draw { get 'index' => 'api/v2/dummy#index' }
    end

    define_dummy_controller(APIParticulier::V2::DummyController)

    it 'adds api: particulier to logstasher' do
      expect(LogStasher).to receive(:build_logstash_event).with(
        hash_including(
          api: 'particulier'
        ),
        anything
      )

      make_call
    end

    it 'adds api_version v2 to logstasher' do
      expect(LogStasher).to receive(:build_logstash_event).with(
        hash_including(
          api_version: 'v2'
        ),
        anything
      )

      make_call
    end

    describe 'with params' do
      subject(:make_call) do
        get :index, params:
      end

      let(:params) { { api_version: '51', foo: 'bar', prenom: 'lol' } }
      let(:hashed_params) { Digest::SHA512.hexdigest("#{Siade.credentials[:api_particulier_log_salt_key]}:#{params.to_json}") }

      it 'adds hashed params to logstasher parameters key' do
        expect(LogStasher).to receive(:build_logstash_event).with(
          hash_including(
            parameters: hash_including(
              hashed_params:
            )
          ),
          anything
        )

        make_call
      end
    end

    describe 'without params' do
      subject(:make_call) do
        get :index
      end

      it 'does not add hashed params to logstasher parameters key' do
        expect(LogStasher).to receive(:build_logstash_event).with(
          hash_excluding(
            parameters: anything
          ),
          anything
        )

        make_call
      end
    end
  end

  describe 'on api particulier franceconnectable request' do
    before do
      routes.draw { get 'index' => 'api/v2/dummy#index' }
      allow(Siade.credentials).to receive(:[]).and_call_original
      allow(Siade.credentials).to receive(:[]).with(:france_connect_v2_dummy_france_connected_client_id).and_return('dummy')
      allow(Siade.credentials).to receive(:[]).with(:france_connect_v2_dummy_france_connected_client_secret).and_return('dummy')
    end

    define_dummy_controller(APIParticulier::V2::DummyFranceConnectedController)

    describe 'with valid FranceConnect bearer token' do
      subject(:make_call) do
        request.headers['Authorization'] = "Bearer #{token}"

        get :index
      end

      before do
        mock_valid_france_connect_checktoken
      end

      let(:token) { 'token' }

      let(:expected_france_connect_params_hash) do
        identity = {
          gender: 'male',
          family_name: 'DUPONT',
          given_name: 'Jean Martin',
          given_name_array: %w[Jean Martin],
          birthdate: france_connect_default_birthdate,
          birthplace: '75101',
          birthcountry: '99100',
          preferred_username: nil
        }

        france_connect_params = {
          id: '6925fb8143c76eded44d32b40c0cb1006065f7f003de52712b78985704f39950',
          name: 'no_data_from_fc_v2',
          identity:
        }

        Digest::SHA512.hexdigest("#{Siade.credentials[:api_particulier_log_salt_key]}:#{france_connect_params}")
      end

      it 'adds hashed_france_connect_token to parameters' do
        expect(LogStasher).to receive(:build_logstash_event).with(
          hash_including(
            parameters: hash_including(
              hashed_params: expected_france_connect_params_hash
            )
          ),
          anything
        )

        make_call
      end

      it 'adds france_connect_client to params' do
        expect(LogStasher).to receive(:build_logstash_event).with(
          hash_including(
            parameters: hash_including(
              france_connect_client: {
                id: '6925fb8143c76eded44d32b40c0cb1006065f7f003de52712b78985704f39950',
                name: 'no_data_from_fc_v2',
                sub: '2fa48e3542c8645567f983efc96305808ae7d3f0d9cc4016ef40c3cde44844cfv1'
              }
            )
          ),
          anything
        )

        make_call
      end
    end

    describe 'when it is in staging, with a mocked payload available' do
      subject(:make_call) do
        request.headers['Authorization'] = "Bearer #{token}"

        get :index
      end

      let(:token) { 'token' }

      before do
        allow(Rails.env).to receive_messages(env: 'staging', staging?: true)

        mock_invalid_france_connect_checktoken

        allow(MockDataBackend).to receive(:get_response_for).with('france_connect', anything).and_return(nil)
        allow(MockDataBackend).to receive(:get_response_for).with('france_connect_v2', anything).and_return(
          {
            status: 200,
            payload: france_connect_decrypted_payload(scopes: ['allowed_scope']).deep_stringify_keys
          }
        )
      end

      it 'does not add france_connect_client to params' do
        expect(LogStasher).to receive(:build_logstash_event).with(
          hash_not_including(
            parameters: anything
          ),
          anything
        )

        make_call
      end
    end
  end

  describe 'on api entreprise request' do
    context 'when it is a v3 and more' do
      let(:api_controller_name) { 'api/v3_and_more/dummy' }

      before do
        routes.draw { get 'index' => 'api/v3_and_more/dummy#index' }
      end

      define_dummy_controller(APIEntreprise::V3AndMore::DummyController)

      it 'adds api: entreprise to logstasher' do
        expect(LogStasher).to receive(:build_logstash_event).with(
          hash_including(
            api: 'entreprise'
          ),
          anything
        )

        make_call
      end

      it 'adds api_version path param to logstasher' do
        expect(LogStasher).to receive(:build_logstash_event).with(
          hash_including(
            api_version: 'v42'
          ),
          anything
        )

        make_call
      end
    end
  end

  describe 'with jwt token, on an authenticate controller' do
    before do
      routes.draw { get 'index' => 'api_entreprise#index' }
      clean_logstasher_store!
    end

    controller(APIEntrepriseController) do
      def index
        head :ok
      end
    end

    let(:clean_logstasher_store!) do
      LogStasher.store['user_access'] = {}
    end

    context 'when token is valid' do
      subject(:make_call) do
        request.headers['Authorization'] = "Bearer #{yes_jwt}"
        get :index, params: { context: 'context', recipient: valid_siret(:recipient), object: 'object' }
      end

      it 'adds jwt info logstasher' do
        expect(LogStasher).to receive(:build_logstash_event).with(
          hash_including(
            'user_access' => hash_including(
              user: yes_jwt_user.logstash_id,
              jti: yes_jwt_user.token_id,
              iat: yes_jwt_user.iat
            )
          ),
          anything
        )

        make_call
      end

      context 'when token is cached' do
        before do
          JwtTokenService.instance.extract_user(yes_jwt)

          reclean_logstasher_store!
        end

        let(:reclean_logstasher_store!) do
          LogStasher.store['user_access'] = {}
        end

        it 'adds jwt info logstasher' do
          expect(LogStasher).to receive(:build_logstash_event).with(
            hash_including(
              'user_access' => hash_including(
                user: yes_jwt_user.logstash_id,
                jti: yes_jwt_user.token_id,
                iat: yes_jwt_user.iat
              )
            ),
            anything
          )

          make_call
        end
      end
    end

    context 'when token is expired' do
      subject(:make_call) do
        request.headers['Authorization'] = "Bearer #{expired_jwt}"

        get :index, params: { context: 'context', recipient: valid_siret(:dgfip), object: 'object' }
      end

      it 'adds jwt info logstasher' do
        expect(LogStasher).to receive(:build_logstash_event).with(
          hash_including(
            'user_access' => hash_including(
              user: expired_jwt_user.logstash_id,
              jti: expired_jwt_user.token_id,
              iat: expired_jwt_user.iat
            )
          ),
          anything
        )

        make_call
      end
    end
  end

  describe 'mcp controller' do
    subject(:make_call) do
      get :index, params:
    end

    let(:params) do
      mcp_params.merge(
        'jsonrpc' => '2.0',
        'id' => 7,
        'mcp' => mcp_params.merge(
          'jsonrpc' => '2.0',
          'id' => 7
        )
      )
    end

    before do
      routes.draw { get 'index' => 'mcp#index' }
    end

    define_dummy_controller(MCPController)

    context 'with tool call' do
      let(:mcp_params) do
        {
          'method' => 'tools/call',
          'params' => {
            'name' => 'insee/unite_legale',
            'arguments' => {
              'siren' => '130025265'
            }
          }
        }
      end

      it 'overrides route with tool name and params with arguments' do
        expect(LogStasher).to receive(:build_logstash_event).with(
          hash_including(
            route: 'insee/unite_legale',
            parameters: { 'siren' => '130025265' }
          ),
          anything
        )

        make_call
      end
    end

    context 'with another call' do
      let(:mcp_params) do
        {
          'method' => 'tools/list',
          'params' => {}
        }
      end

      it 'sets should_be_stored_in_database to false' do
        expect(LogStasher).to receive(:build_logstash_event).with(
          hash_including(
            should_be_stored_in_database: false
          ),
          anything
        )

        make_call
      end
    end
  end
end
