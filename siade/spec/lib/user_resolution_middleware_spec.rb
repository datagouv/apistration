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

    it 'stores the token the user was resolved from' do
      call

      expect(env[described_class::TOKEN_ENV_KEY]).to eq(yes_jwt)
    end
  end

  context 'with a token which cannot be extracted' do
    let(:token) { 'not a valid jwt token' }

    it 'lets the request through without user' do
      expect(call).to eq([200, {}, [nil]])
    end

    it 'stores the presented token and why it cannot be extracted' do
      call

      expect(env).to include(
        described_class::TOKEN_ENV_KEY => token,
        described_class::TOKEN_EXTRACTION_FAILURE_REASON_ENV_KEY => :malformed
      )
    end
  end

  context 'with an undecodable Authorization header and a valid token query param' do
    let(:env) { Rack::MockRequest.env_for("/?token=#{yes_jwt}", 'HTTP_AUTHORIZATION' => 'Bearer not-a-jwt') }

    it 'resolves the user from the query param, so every layer controls it' do
      expect(call.last.first).to be_a(JwtUser)
    end

    it 'stores the query param token without any extraction failure' do
      call

      expect(env[described_class::TOKEN_ENV_KEY]).to eq(yes_jwt)
      expect(env).not_to have_key(described_class::TOKEN_EXTRACTION_FAILURE_REASON_ENV_KEY)
    end
  end

  context 'with a non Bearer Authorization header, an X-Api-Key and a token query param' do
    let(:env) do
      Rack::MockRequest.env_for('/?token=another.token', 'HTTP_AUTHORIZATION' => 'Basic whatever', 'HTTP_X_API_KEY' => yes_jwt)
    end

    it 'resolves the user from the X-Api-Key header' do
      call

      expect(env[described_class::TOKEN_ENV_KEY]).to eq(yes_jwt)
    end
  end

  context 'when the request has already been resolved' do
    let(:token) { yes_jwt }

    before { described_class.resolve(env) }

    it 'does not extract the token again' do
      allow(JwtTokenService.instance).to receive(:extract_user)

      call

      expect(JwtTokenService.instance).not_to have_received(:extract_user)
    end
  end
end
