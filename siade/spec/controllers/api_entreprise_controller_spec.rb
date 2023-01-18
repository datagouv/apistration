RSpec.describe APIEntrepriseController do
  controller(described_class) do
    def index
      render json: {}, status: :ok
    end

    def show
      1.lol

      render json: {}, status: :ok
    end
  end

  let(:token) { yes_jwt }

  context 'when in staging environement' do
    before do
      allow(Rails.env).to receive(:staging?).and_return(true)

      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(MockableInStaging)
        .to receive(:json)
        .and_return(dummy: 'example value')
      # rubocop:enable RSpec/AnyInstance
    end

    it 'runs mandatory params before trying to mock response' do
      get :index, params: { token: }
      assert_response 422
    end

    it 'check scopes before trying to mock response' do
      get :index, params: { token: TokenFactory.new('not_allowed').valid }
      assert_response 403
    end
  end

  describe 'non-regression test: when there is a no method error' do
    subject(:make_request) do
      routes.draw { get 'show' => 'api_entreprise#show' }

      get :show, params: mandatory_params
    end

    before { request.headers['Authorization'] = "Bearer #{token}" }

    it 'raises this error' do
      expect {
        make_request
      }.to raise_error(NoMethodError)
    end
  end
end
