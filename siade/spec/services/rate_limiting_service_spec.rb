RSpec.describe RateLimitingService do
  let(:req) { instance_double(Rack::Request) }
  let(:env) { {} }

  before do
    allow(req).to receive_messages(params: {}, env:)
  end

  describe '#discriminate_by_authorization_request_for_endpoints' do
    subject { described_class.new.discriminate_by_authorization_request_for_endpoints(req, endpoints) }

    let(:endpoints) do
      [
        {
          controller: 'api_entreprise/v3_and_more/insee/etablissements',
          action: 'show'
        },
        {
          controller: 'api_entreprise/v3_and_more/insee/unites_legales',
          action: 'show'
        },
        {
          controller: 'api_entreprise/v3_and_more/dgfip/liasses_fiscales',
          action: 'show'
        }
      ]
    end

    let(:base_path) { 'http://entreprise.api.localtest.me' }

    before do
      allow(req).to receive(:url).and_return("#{base_path}/random/path")
      allow(req).to receive(:get_header).with('HTTP_X_API_KEY').and_return(nil)
      allow(req).to receive(:get_header).with('HTTP_AUTHORIZATION').and_return(nil)
    end

    context 'when no user is resolved' do
      it { is_expected.to be_nil }
    end

    context 'when the token does not resolve to a user (opaque token)' do
      let(:opaque_token) { 'random.opaque.token' }

      before do
        allow(req).to receive(:get_header).with('HTTP_AUTHORIZATION').and_return("Bearer #{opaque_token}")
        allow(req).to receive(:url).and_return("#{base_path}/v3/insee/sirene/etablissements/0001")
      end

      it 'falls back to the token hash' do
        expect(subject).to eq(Digest::SHA256.hexdigest(opaque_token))
      end
    end

    context 'with a resolved user having an authorization_request_id' do
      let(:authorization_request_id) { 42 }
      let(:user) do
        JwtUser.new(
          uid: SecureRandom.uuid, jti: SecureRandom.uuid, scopes: [], iat: 1.day.ago.to_i,
          authorization_request_id:
        )
      end

      before { env[UserResolutionMiddleware::USER_ENV_KEY] = user }

      context 'when the request path matches one of the endpoints in the list' do
        before { allow(req).to receive(:url).and_return("#{base_path}/v3/insee/sirene/etablissements/0001") }

        it { is_expected.to eq(authorization_request_id) }
      end

      describe 'non-regression: dgfip v3 attestations_fiscales' do
        before { allow(req).to receive(:url).and_return("#{base_path}/v3/dgfip/unites_legales/301028346/liasses_fiscales/2017") }

        it { is_expected.to eq(authorization_request_id) }
      end

      context 'when the request path does not match any of the endpoints in the list' do
        before { allow(req).to receive(:url).and_return("#{base_path}/not/in/the/list") }

        it { is_expected.to be_nil }
      end
    end

    context 'with a resolved user without authorization_request_id' do
      let(:user) do
        JwtUser.new(uid: SecureRandom.uuid, jti: SecureRandom.uuid, scopes: [], iat: 1.day.ago.to_i)
      end

      before do
        env[UserResolutionMiddleware::USER_ENV_KEY] = user
        allow(req).to receive(:url).and_return("#{base_path}/v3/insee/sirene/etablissements/0001")
      end

      it 'falls back to token identifier' do
        expect(subject).to eq("token:#{user.token_id}")
      end
    end

    context 'with an editor user having a resolved authorization_request_id' do
      let(:editor_id) { SecureRandom.uuid }
      let(:authorization_request_id) { 42 }
      let(:user) do
        JwtUser.new(
          uid: SecureRandom.uuid, jti: SecureRandom.uuid, scopes: [], iat: 1.day.ago.to_i,
          editor_id:, authorization_request_id:
        )
      end

      before do
        env[UserResolutionMiddleware::USER_ENV_KEY] = user
        allow(req).to receive(:url).and_return("#{base_path}/v3/insee/sirene/etablissements/0001")
      end

      it 'uses the resolved authorization request as discriminator' do
        expect(subject).to eq(authorization_request_id)
      end
    end

    context 'with an editor user without a resolved authorization request' do
      let(:editor_id) { SecureRandom.uuid }
      let(:user) do
        JwtUser.new(
          uid: SecureRandom.uuid, jti: SecureRandom.uuid, scopes: [], iat: 1.day.ago.to_i,
          editor_id:
        )
      end

      before do
        env[UserResolutionMiddleware::USER_ENV_KEY] = user
        allow(req).to receive(:url).and_return("#{base_path}/v3/insee/sirene/etablissements/0001")
      end

      it 'falls back to the editor identifier' do
        expect(subject).to eq("editor:#{editor_id}")
      end
    end
  end

  describe '#whitelisted_access?' do
    subject { described_class.new.whitelisted_access?(req) }

    before do
      allow(req).to receive(:get_header).with('HTTP_X_API_KEY').and_return(nil)
    end

    context 'when authorization header is not set' do
      before { allow(req).to receive(:get_header).with('HTTP_AUTHORIZATION').and_return(nil) }

      it { is_expected.to be(false) }
    end

    context 'when authorization header is set' do
      context 'when the Bearer format is not respected' do
        before { allow(req).to receive(:get_header).with('HTTP_AUTHORIZATION').and_return('Beer hour') }

        it { is_expected.to be(false) }
      end

      context 'when the Bearer is well formed' do
        before { allow(req).to receive(:get_header).with('HTTP_AUTHORIZATION').and_return("Bearer #{token}") }

        context 'when the token is whitelisted' do
          let(:token) { Rails.configuration.jwt_whitelist.sample }

          it { is_expected.to be(true) }
        end

        context 'when the token is not whitelisted' do
          let(:token) { 'random token' }

          it { is_expected.to be(false) }
        end
      end
    end
  end

  describe '#blacklisted_access?' do
    subject { described_class.new.blacklisted_access?(req) }

    context 'when no user is resolved' do
      it { is_expected.to be(false) }
    end

    context 'when user is resolved and blacklisted' do
      let(:user) do
        JwtUser.new(uid: SecureRandom.uuid, jti: SecureRandom.uuid, scopes: [], iat: 1.day.ago.to_i, blacklisted: true)
      end

      before { env[UserResolutionMiddleware::USER_ENV_KEY] = user }

      it { is_expected.to be(true) }
    end

    context 'when user is resolved and not blacklisted' do
      let(:user) do
        JwtUser.new(uid: SecureRandom.uuid, jti: SecureRandom.uuid, scopes: [], iat: 1.day.ago.to_i)
      end

      before { env[UserResolutionMiddleware::USER_ENV_KEY] = user }

      it { is_expected.to be(false) }
    end
  end

  describe '#ip_forbidden_access?' do
    subject { described_class.new.ip_forbidden_access?(req) }

    before { allow(req).to receive(:ip).and_return(request_ip) }

    let(:request_ip) { '8.8.8.8' }

    context 'when no user is resolved' do
      it { is_expected.to be(false) }
    end

    context 'with a resolved user' do
      context 'without IP whitelist configured' do
        let(:user) do
          JwtUser.new(uid: SecureRandom.uuid, jti: SecureRandom.uuid, scopes: [], iat: 1.day.ago.to_i)
        end

        before { env[UserResolutionMiddleware::USER_ENV_KEY] = user }

        it { is_expected.to be(false) }
      end

      context 'with IP whitelist configured' do
        let(:user) do
          JwtUser.new(
            uid: SecureRandom.uuid, jti: SecureRandom.uuid, scopes: [], iat: 1.day.ago.to_i,
            allowed_ips: ['192.168.1.0/24']
          )
        end

        before { env[UserResolutionMiddleware::USER_ENV_KEY] = user }

        context 'when request IP is allowed' do
          let(:request_ip) { '192.168.1.50' }

          it { is_expected.to be(false) }
        end

        context 'when request IP is not allowed' do
          let(:request_ip) { '8.8.8.8' }

          it { is_expected.to be(true) }
        end
      end
    end
  end

  describe '#custom_rate_limit_for' do
    subject { described_class.new.custom_rate_limit_for(req) }

    context 'when no user is resolved' do
      it { is_expected.to be_nil }
    end

    context 'with a resolved user without custom rate limit' do
      let(:user) do
        JwtUser.new(uid: SecureRandom.uuid, jti: SecureRandom.uuid, scopes: [], iat: 1.day.ago.to_i)
      end

      before { env[UserResolutionMiddleware::USER_ENV_KEY] = user }

      it { is_expected.to be_nil }
    end

    context 'with a resolved user with custom rate limit' do
      let(:user) do
        JwtUser.new(
          uid: SecureRandom.uuid, jti: SecureRandom.uuid, scopes: [], iat: 1.day.ago.to_i,
          rate_limit_per_minute: 100
        )
      end

      before { env[UserResolutionMiddleware::USER_ENV_KEY] = user }

      it { is_expected.to eq(100) }
    end
  end

  describe '#custom_rate_limit?' do
    subject { described_class.new.custom_rate_limit?(req) }

    context 'when no user is resolved' do
      it { is_expected.to be(false) }
    end

    context 'with a resolved user with custom rate limit' do
      let(:user) do
        JwtUser.new(
          uid: SecureRandom.uuid, jti: SecureRandom.uuid, scopes: [], iat: 1.day.ago.to_i,
          rate_limit_per_minute: 100
        )
      end

      before { env[UserResolutionMiddleware::USER_ENV_KEY] = user }

      it { is_expected.to be(true) }
    end
  end
end
