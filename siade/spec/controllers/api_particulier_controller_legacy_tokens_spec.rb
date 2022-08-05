# rubocop:disable RSpec/DescribeMethod
# rubocop:disable Naming/VariableNumber
RSpec.describe APIParticulierController, 'legacy tokens', type: :controller do
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

  subject(:make_call) do
    routes.draw { get 'show' => 'api_particulier#show' }

    get :show, params: { token: }
  end

  before do
    allow(LogStasher).to receive(:build_logstash_event)
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
# rubocop:enable Naming/VariableNumber
