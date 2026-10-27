require 'rails_helper'

RSpec.describe 'GET /auth/proconnect_api_entreprise/callback' do
  subject(:callback) do
    post '/auth/proconnect_api_entreprise'
    state = Rack::Utils.parse_query(URI(response.location.to_s).query)['state']

    get '/auth/proconnect_api_entreprise/callback', params: { code: 'authorization-code', state: }, env: { 'REMOTE_ADDR' => '203.0.113.4' }
  end

  let(:user) { create(:user) }
  let(:userinfo) do
    JSON::JWT.new(
      sub: user.oauth_api_gouv_id,
      email: user.email,
      given_name: user.first_name,
      usual_name: user.last_name,
      idp_id: 'idp-uuid'
    ).to_s
  end
  let(:logstash_output) { StringIO.new }
  let(:logstash_line) { JSON.parse(logstash_output.string.lines.last) }

  before do
    host! 'entreprise.api.localtest.me'
    allow(LogStasher).to receive(:logger).and_return(Logger.new(logstash_output))

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

    it 'logs the login attempt in the logstash line of the callback' do
      callback

      expect(logstash_line).to include(
        'ip' => '203.0.113.4',
        'security_events' => [
          {
            'event' => 'auth.login.attempted',
            'actor' => { 'email' => user.email, 'role' => 'user' },
            'target' => { 'type' => 'user', 'id' => user.id },
            'details' => { 'method' => 'proconnect', 'idp' => 'idp-uuid', 'mfa' => true, 'acr' => 'eidas1-mfa' }
          }
        ]
      )
    end
  end

  context 'when ProConnect did not perform MFA' do
    let(:acr) { 'eidas1' }

    it 'redirects to the login page' do
      callback

      expect(response).to redirect_to(login_url)
    end

    it 'logs the denied login attempt in the logstash line of the callback' do
      callback

      expect(logstash_line['security_events'].sole).to include(
        'event' => 'auth.login.attempted',
        'details' => hash_including('outcome' => 'denied', 'reason' => 'mfa_missing', 'acr' => 'eidas1', 'idp' => 'idp-uuid')
      )
    end
  end
end
