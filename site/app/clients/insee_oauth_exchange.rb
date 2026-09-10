class INSEEOAuthExchange
  Attempt = Data.define(:status, :token, :expires_in)

  OAUTH_URL = 'https://auth.insee.net/auth/realms/apim-gravitee/protocol/openid-connect/token'.freeze
  TIMEOUT = 5
  INVALID_GRANT_HTTP_STATUSES = [400, 401].freeze
  TRANSIENT_HTTP_STATUSES = [408, 429].freeze

  def attempt(password)
    response = post_credentials(password)
    payload = parsed_body(response)

    return granted_attempt(payload) if granted?(response, payload)

    rejected_attempt(rejection_status(response, payload))
  rescue Faraday::Error
    rejected_attempt(:unavailable)
  end

  private

  def post_credentials(password)
    http_connection.post(
      OAUTH_URL,
      {
        'grant_type' => 'password',
        'client_id' => AdminApientreprise.credentials[:insee_client_id],
        'client_secret' => AdminApientreprise.credentials[:insee_client_secret],
        'username' => AdminApientreprise.credentials[:insee_username],
        'password' => password
      }.to_query
    )
  end

  def granted?(response, payload)
    response.status == 200 && payload['access_token'].present?
  end

  def rejection_status(response, payload)
    return :unavailable if TRANSIENT_HTTP_STATUSES.include?(response.status)
    return :invalid_grant if invalid_grant?(response, payload)
    return :rejected if response.status.between?(400, 499)

    :unavailable
  end

  def invalid_grant?(response, payload)
    INVALID_GRANT_HTTP_STATUSES.include?(response.status) && payload['error'] == 'invalid_grant'
  end

  def granted_attempt(payload)
    Attempt.new(status: :granted, token: payload['access_token'], expires_in: payload['expires_in'])
  end

  def rejected_attempt(status)
    Attempt.new(status:, token: nil, expires_in: nil)
  end

  def parsed_body(response)
    JSON.parse(response.body.to_s)
  rescue JSON::ParserError
    {}
  end

  def http_connection
    @http_connection ||= Faraday.new do |conn|
      conn.options.timeout = TIMEOUT
      conn.headers['Content-Type'] = 'application/x-www-form-urlencoded'
    end
  end
end
