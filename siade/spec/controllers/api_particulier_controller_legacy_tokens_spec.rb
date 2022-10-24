# rubocop:disable RSpec/DescribeMethod
RSpec.describe APIParticulierController, 'legacy tokens' do
  # rubocop:enable RSpec/DescribeMethod
  controller(described_class) do
    def show
      authorize :scope1, :scope2

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

      it 'tracks invalid token (for debugging purpose)' do
        make_call

        expect(MonitoringService.instance).to have_received(:track).with(
          'error',
          'Invalid token but legit format for legacy token',
          {
            legacy_token_value: token
          }
        )
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

      it 'tracks invalid token (for debugging purpose)' do
        make_call

        expect(MonitoringService.instance).to have_received(:track).with(
          'error',
          'Invalid token but legit format for legacy token',
          {
            legacy_token_value: token
          }
        )
      end
    end
  end

  context 'when token is in params' do
    subject(:make_call) do
      routes.draw { get 'show' => 'api_particulier#show' }

      get :show, params: { token: }
    end

    context 'with jwt token' do
      let(:token) { TokenFactory.new(scopes).valid }

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

    context 'with legacy token' do
      describe 'with at least one valid scope' do
        let(:token) { '1_scope' }

        its(:status) { is_expected.to eq(200) }

        its(:body) do
          is_expected.to eq({
            scope1: 'scope1'
          }.to_json)
        end

        it 'adds jwt info logstasher' do
          expect(LogStasher).to receive(:build_logstash_event).with(
            hash_including(
              'user_access' => hash_including(
                user: '99999999-9999-9999-9999-999999999999',
                jti: '11111111-1111-1111-1111-111111111110'
              )
            ),
            anything
          )

          make_call
        end
      end

      describe 'without valid scope' do
        let(:token) { '1_another_scope' }

        its(:status) { is_expected.to eq(401) }

        its(:body) do
          is_expected.to include('access_denied')
        end

        it 'does not track invalid token (because it is a valid one)' do
          make_call

          expect(MonitoringService.instance).not_to have_received(:track).with(
            'error',
            'Invalid token but legit format for legacy token',
            anything
          )
        end
      end

      describe 'with multiple valid scopes' do
        let(:token) { '2_scopes' }

        its(:status) { is_expected.to eq(200) }

        its(:body) do
          is_expected.to eq({
            scope1: 'scope1',
            scope2: 'scope2'
          }.to_json)
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
