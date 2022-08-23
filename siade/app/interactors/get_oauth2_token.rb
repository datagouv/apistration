class GetOAuth2Token < MakeRequest::Post
  def call
    context.token = token_from_redis || retrieve_and_save_token
  end

  protected

  def client_url
    fail NotImplementedError
  end

  def client_id
    nil
  end

  def client_secret
    nil
  end

  def scope
    nil
  end

  def access_token(response)
    parsed_response(response)['access_token']
  end

  def expires_in(response)
    parsed_response(response)['expires_in']
  end

  def parsed_response(response)
    @parsed_response ||= JSON.parse(response.body)
  end

  private

  def response_not_defined?
    context.token.nil?
  end

  def request_uri
    URI(client_url)
  end

  def form_data
    {
      client_id:,
      client_secret:,
      grant_type: 'client_credentials',
      scope:
    }.compact
  end

  def redis_token_key
    self
      .class
      .name
      .underscore
      .to_sym
  end

  def retrieve_and_save_token
    response = api_call

    redis.set(redis_token_key, access_token(response), ex: expires_in(response))

    token_from_redis
  end

  def token_from_redis
    redis.get(redis_token_key)
  end

  def redis
    @redis ||= RedisService.instance
  end
end
