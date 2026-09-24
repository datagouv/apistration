RSpec.describe 'Token sent to the wrong environment' do
  subject(:make_request) { get url, headers: }

  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  let(:payload) { TokenFactory.new(Scope.all).payload(uid: SecureRandom.uuid) }
  let(:token) { JWT.encode(payload, 'another environment secret', Siade.credentials[:jwt_hash_algo]) }
  let(:first_error) { response.parsed_body['errors'].first }

  after { Rack::Attack.reset! }

  describe 'API Entreprise', api: :entreprise do
    let(:url) { '/v3/opqibi/unites_legales/123456789/certification_ingenierie' }

    context 'when a production token is sent to staging' do
      before do
        allow(Rails.env).to receive(:staging?).and_return(true)
        make_request
      end

      it { expect(response).to have_http_status(:unauthorized) }

      it 'renders the production token on staging error' do
        expect(first_error).to include('code' => '00108', 'detail' => ProductionTokenOnStagingError.new.detail)
      end
    end

    context 'when a staging token is sent to production' do
      let(:payload) { super().merge(sub: 'staging', jti: JwtTokenService::STAGING_TOKEN_JTI) }

      before do
        allow(Rails.env).to receive(:production?).and_return(true)
        make_request
      end

      it { expect(response).to have_http_status(:unauthorized) }

      it 'renders the staging token on production error' do
        expect(first_error).to include('code' => '00109', 'detail' => StagingTokenOnProductionError.new('api_entreprise').detail)
      end
    end

    context 'when the payload is not an object' do
      let(:token) { JWT.encode([], 'another environment secret', Siade.credentials[:jwt_hash_algo]) }

      before do
        allow(Rails.env).to receive(:staging?).and_return(true)
        make_request
      end

      it 'renders the invalid token error' do
        expect(first_error).to include('code' => '00101', 'detail' => "Votre token n'est pas valide")
      end
    end
  end

  describe 'API Particulier v2' do
    let(:url) { '/api/v2/composition-familiale-v2' }
    let(:headers) { { 'X-Api-Key' => token } }
    let(:payload) { super().merge(sub: 'staging') }

    before do
      host! 'particulier.api.localtest.me'
      allow(Rails.env).to receive(:production?).and_return(true)
      make_request
    end

    it { expect(response).to have_http_status(:unauthorized) }

    it 'renders the staging token on production error' do
      detail = StagingTokenOnProductionError.new('api_particulier').detail

      expect(response.parsed_body).to eq('error' => 'access_denied', 'reason' => detail, 'message' => detail)
    end
  end
end
