RSpec.describe UserResolutionMiddleware do
  subject(:call) { middleware.call(env) }

  let(:middleware) { described_class.new(app) }
  let(:app) { ->(env) { [200, {}, [env[described_class::USER_ENV_KEY]]] } }
  let(:env) { Rack::MockRequest.env_for('/', 'HTTP_AUTHORIZATION' => "Bearer #{token}") }

  context 'with a valid token' do
    let(:token) { yes_jwt }

    it 'resolves the user' do
      expect(call.last.first).to be_a(JwtUser)
    end
  end

  context 'with a token which cannot be extracted' do
    let(:token) { 'not a valid jwt token' }

    it 'lets the request through without user' do
      expect(call).to eq([200, {}, [nil]])
    end
  end
end
