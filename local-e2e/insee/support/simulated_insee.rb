class SimulatedINSEE
  attr_accessor :oauth_fault, :renewal_fault, :after_oauth, :before_resource, :oauth_delay, :expires_in, :reject_resources

  def initialize(redis)
    @redis = redis
    @expires_in = 3600
  end

  def password=(password)
    @redis.set('password', password)
  end

  def password
    @redis.get('password')
  end

  def attempts
    @redis.lrange('attempts', 0, -1)
  end

  def bearers
    @redis.lrange('bearers', 0, -1)
  end

  def renewals
    @redis.get('renewals').to_i
  end

  def issue_token
    token = "smoke-token-#{@redis.incr('issued_tokens')}"
    @redis.sadd('valid_tokens', token)
    token
  end

  def revoke_tokens
    @redis.del('valid_tokens')
  end

  def authenticate(request)
    parameters = URI.decode_www_form(request.body).to_h
    @redis.rpush('attempts', parameters.fetch('password'))
    sleep(oauth_delay) if oauth_delay
    response = oauth_response(parameters)
    after_oauth&.call
    response
  end

  def renew(request)
    @redis.incr('renewals')
    raise Net::ReadTimeout if renewal_fault == :timeout
    return response(renewal_fault, message: 'renewal unavailable') if renewal_fault && renewal_fault != :timeout_after_rotation

    parameters = JSON.parse(request.body)
    return response(401, message: 'invalid bearer') unless valid_token?(request)
    return response(400, message: 'wrong old password') unless parameters.fetch('oldPassword') == password

    self.password = parameters.fetch('newPassword')
    revoke_tokens
    raise Net::ReadTimeout if renewal_fault == :timeout_after_rotation

    response(200, {})
  end

  def resource(request)
    @redis.rpush('bearers', request.headers.fetch('Authorization'))
    before_resource&.call
    return response(401, message: 'invalid bearer') if reject_resources || !valid_token?(request)

    response(200, uniteLegale: { siren: '123456789' }, etablissement: { siret: '12345678900001' })
  end

  private

  def oauth_response(parameters)
    raise Net::ReadTimeout if oauth_fault == :timeout
    return response(400, error: 'invalid_client') if oauth_fault == :invalid_client
    return response(oauth_fault, error: 'unavailable') if oauth_fault
    return response(400, error: 'invalid_client') unless valid_client?(parameters)
    return response(401, error: 'invalid_grant') unless parameters.fetch('password') == password

    response(200, access_token: issue_token, expires_in:)
  end

  def valid_client?(parameters)
    parameters.values_at('client_id', 'client_secret', 'username', 'grant_type') ==
      %w[smoke-client smoke-secret smoke-user password]
  end

  def valid_token?(request)
    @redis.sismember('valid_tokens', request.headers.fetch('Authorization').delete_prefix('Bearer '))
  end

  def response(status, body)
    { status:, body: body.to_json, headers: { 'Content-Type' => 'application/json' } }
  end
end
