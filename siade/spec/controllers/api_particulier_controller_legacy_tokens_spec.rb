RSpec.describe APIParticulierController, 'legacy tokens' do
  # rubocop:enable RSpec/DescribeMethod
  controller(described_class) do
    def show
      render json: serializer_class.new(data, serializer_base_options).serializable_hash
    end

    def data
      Resource.new(
        scope1: 'scope1',
        scope2: 'scope2'
      )
    end

    def serializer_class
      Class.new(APIParticulier::V2BaseSerializer) do
        attribute :scope1, if: -> { scope?('scope1') }
        attribute :scope2, if: -> { scope?('scope2') }
      end
    end
  end

  before do
    allow(LogStasher).to receive(:build_logstash_event)
    allow(MonitoringService.instance).to receive(:track)
    clean_logstasher_store!
  end

  let(:clean_logstasher_store!) do
    LogStasher.store['user_access'] = {}
  end

  context 'without any token' do
    subject(:make_call) do
      routes.draw { get 'show' => 'api_particulier#show' }

      get :show
    end

    its(:status) { is_expected.to eq(401) }

    its(:body) do
      is_expected.to include('access_denied')
    end

    it 'does not track invalid token' do
      make_call

      expect(MonitoringService.instance).not_to have_received(:track).with(
        'error',
        'Invalid token but legit format for legacy token',
        anything
      )
    end
  end

  context 'with invalid token value which can be a legacy token, but not registered in the backend' do
    let(:token) { 'a' * 60 }

    context 'when it is in query params' do
      subject(:make_call) do
        routes.draw { get 'show' => 'api_particulier#show' }

        get :show, params: { token: }
      end

      its(:status) { is_expected.to eq(401) }

      its(:body) do
        is_expected.to include('access_denied')
      end
    end

    context 'when it is in header' do
      subject(:make_call) do
        routes.draw { get 'show' => 'api_particulier#show' }

        request.headers['X-Api-Key'] = token

        get :show
      end

      its(:status) { is_expected.to eq(401) }

      its(:body) do
        is_expected.to include('access_denied')
      end
    end
  end

  context 'when token is in params' do
    subject(:make_call) do
      routes.draw { get 'show' => 'api_particulier#show' }

      get :show, params: { token: }
    end

    shared_examples 'a classic JWT' do
      before do
        affect_scopes_to_yes_jwt_token(scopes)
      end

      after(:all) do
        reset_yes_jwt_token_scopes!
      end

      describe 'with at least one valid scope' do
        let(:scopes) { ['scope1'] }

        its(:status) { is_expected.to eq(200) }

        its(:body) do
          is_expected.to eq({
            scope1: 'scope1'
          }.to_json)
        end
      end

      describe 'with multiple valid scopes' do
        let(:scopes) { %w[scope1 scope2] }

        its(:status) { is_expected.to eq(200) }

        its(:body) do
          is_expected.to eq({
            scope1: 'scope1',
            scope2: 'scope2'
          }.to_json)
        end
      end

      describe 'without valid scope' do
        let(:scopes) { ['another_scope1'] }

        its(:status) { is_expected.to eq(401) }

        its(:body) do
          is_expected.to include('access_denied')
        end
      end
    end

    context 'with jwt token' do
      let(:token) { TokenFactory.new(scopes).valid }

      it_behaves_like 'a classic JWT'
    end

    context 'with legacy token' do
      let(:token) { 'legacy_token_in_config_file' }

      describe 'when linked to a new token which is valid' do
        before do
          Token.create!(
            id: '55555555-5555-5555-5555-555555555550',
            scopes:,
            iat: 1.day.ago,
            exp: 1.day.from_now,
            authorization_request: AuthorizationRequest.last
          )
        end

        it_behaves_like 'a classic JWT'

        describe 'logging' do
          let(:scopes) { %w[scope1 scope2] }

          it 'adds jwt info to logstasher: user and jti is legacy_token_id from backend file' do
            expect(LogStasher).to receive(:build_logstash_event).with(
              hash_including(
                'user_access' => hash_including(
                  user: '55555555-5555-5555-5555-555555555550',
                  jti: '55555555-5555-5555-5555-555555555550'
                )
              ),
              anything
            )

            make_call
          end
        end
      end

      describe 'when linked to a new token which is expired' do
        let(:token) { 'legacy_token_in_config_file' }

        before do
          Token.create!(
            id: '55555555-5555-5555-5555-555555555550',
            scopes: %w[scope1 scope2],
            iat: 1.year.ago.to_time,
            exp: 1.day.ago.to_time,
            authorization_request: AuthorizationRequest.last
          )
        end

        its(:status) { is_expected.to eq(401) }

        its(:body) do
          is_expected.to include('Votre token est expiré')
        end
      end
    end
  end

  context 'when token is in header' do
    subject(:make_call) do
      routes.draw { get 'show' => 'api_particulier#show' }

      get :show
    end

    context 'when it is bearer token' do
      before do
        request.headers['Authorization'] = "Bearer #{token}"
      end

      context 'when it is a valid jwt token' do
        let(:token) { TokenFactory.new(['scope1']).valid }

        its(:status) { is_expected.to eq(401) }

        it 'does not track invalid token (because it is a valid one)' do
          make_call

          expect(MonitoringService.instance).not_to have_received(:track).with(
            'error',
            'Invalid token but legit format for legacy token',
            anything
          )
        end
      end
    end

    context 'when it is in X-Api-key header' do
      before do
        request.headers['X-Api-Key'] = token

        Token.create!(
          id: '11111111-1111-1111-1111-111111111110',
          scopes: %w[scope1 scope2],
          iat: 1.day.ago,
          exp: 1.day.from_now,
          authorization_request: AuthorizationRequest.last
        )
      end

      context 'when it is a legacy token' do
        let(:token) { '1_scope' }

        its(:status) { is_expected.to eq(200) }
      end

      context 'when it is a valid jwt token' do
        let(:token) { TokenFactory.new(['scope1']).valid }

        its(:status) { is_expected.to eq(200) }
      end
    end
  end
end
