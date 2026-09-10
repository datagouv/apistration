RSpec.describe INSEEOAuthExchange do
  subject(:exchange) { described_class.new }

  def stub_oauth(**response)
    stub_request(:post, described_class::OAUTH_URL).to_return(**response)
  end

  def json_response(status, body)
    { status:, body: body.to_json, headers: { 'Content-Type' => 'application/json' } }
  end

  describe '#attempt' do
    it 'returns the granted token' do
      stub_oauth(**json_response(200, { access_token: 'a-fresh-insee-token', expires_in: 598_077 }))

      expect(exchange.attempt('SomeP4ssword!')).to have_attributes(status: :granted, token: 'a-fresh-insee-token', expires_in: 598_077)
    end

    it 'sends the password INSEE expects' do
      stub_oauth(**json_response(200, { access_token: 'a-fresh-insee-token', expires_in: 598_077 }))

      exchange.attempt('SomeP4ssword!')

      expect(WebMock).to have_requested(:post, described_class::OAUTH_URL).with(body: hash_including('password' => 'SomeP4ssword!'))
    end

    it 'reports a rejected password' do
      stub_oauth(**json_response(401, { error: 'invalid_grant', error_description: 'Invalid user credentials' }))

      expect(exchange.attempt('SomeP4ssword!').status).to eq(:invalid_grant)
    end

    it 'tells a refused OAuth exchange from a rejected password' do
      stub_oauth(**json_response(400, { error: 'invalid_client' }))

      expect(exchange.attempt('SomeP4ssword!').status).to eq(:rejected)
    end

    it 'reports an unavailable OAuth' do
      stub_oauth(status: 500, body: '')

      expect(exchange.attempt('SomeP4ssword!').status).to eq(:unavailable)
    end

    it 'reports a rate limiting as unavailable rather than rejected' do
      stub_oauth(status: 429, body: '', headers: { 'Retry-After' => '2' })

      expect(exchange.attempt('SomeP4ssword!').status).to eq(:unavailable)
    end

    it 'reports a request timeout as unavailable rather than rejected' do
      stub_oauth(status: 408, body: '')

      expect(exchange.attempt('SomeP4ssword!').status).to eq(:unavailable)
    end

    it 'reports a connection timeout as unavailable' do
      stub_request(:post, described_class::OAUTH_URL).to_timeout

      expect(exchange.attempt('SomeP4ssword!').status).to eq(:unavailable)
    end

    it 'reports a non JSON body as unavailable' do
      stub_oauth(status: 200, body: '<html>gateway</html>')

      expect(exchange.attempt('SomeP4ssword!').status).to eq(:unavailable)
    end
  end
end
