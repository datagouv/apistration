require 'rails_helper'

RSpec.describe 'GET /auth/proconnect_api_entreprise/callback' do
  subject(:callback) do
    post '/auth/proconnect_api_entreprise'
    state = Rack::Utils.parse_query(URI(response.location.to_s).query)['state']

    get '/auth/proconnect_api_entreprise/callback', params: { code: 'authorization-code', state: }
  end

  let(:user) { create(:user) }
  let(:userinfo) do
    JSON::JWT.new(
      sub: user.oauth_api_gouv_id,
      email: user.email,
      given_name: user.first_name,
      usual_name: user.last_name
    ).to_s
  end

  before do
    host! 'entreprise.api.localtest.me'

    stub_request(:get, %r{/.well-known/openid-configuration}).and_return(
      status: 200,
      headers: { 'Content-Type' => 'application/json' },
      body: {
        authorization_endpoint: 'https://proconnect.test/authorize',
        token_endpoint: 'https://proconnect.test/token',
        userinfo_endpoint: 'https://proconnect.test/userinfo'
      }.to_json
    )
    stub_request(:post, 'https://proconnect.test/token').and_return(
      status: 200,
      headers: { 'Content-Type' => 'application/json' },
      body: { access_token: 'access-token', id_token: JSON::JWT.new(acr:).to_s }.to_json
    )
    stub_request(:get, 'https://proconnect.test/userinfo').and_return(
      status: 200,
      headers: { 'Content-Type' => 'application/jwt' },
      body: userinfo
    )
  end

  context 'when ProConnect performed MFA' do
    let(:acr) { 'eidas1-mfa' }

    it 'signs the user in' do
      callback

      expect(response).to redirect_to(authorization_requests_url)
    end
  end

  context 'when ProConnect did not perform MFA' do
    let(:acr) { 'eidas1' }

    it 'redirects to the login page' do
      callback

      expect(response).to redirect_to(login_url)
    end
  end
end
