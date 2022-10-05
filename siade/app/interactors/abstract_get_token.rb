class AbstractGetToken < MakeRequest::Post
  def call
    context.token = token_from_redis || retrieve_and_save_token
  end

  protected

  def client_url
    fail NotImplementedError
  end

  def expires_in(response)
    fail NotImplementedError
  end

  def access_token(response)
    fail NotImplementedError
  end

  private

  def response_not_defined?
    context.token.nil?
  end

  def request_uri
    URI(client_url)
  end

  def redis_token_key
    self
      .class
      .name
      .underscore
      .to_sym
  end

  def retrieve_and_save_token
    response = api_call_with_error_handling

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
