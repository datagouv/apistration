class AbstractGetToken < MakeRequest::Post
  def call
    return if use_mocked_data?

    context.token = token_from_cache || retrieve_and_save_token
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

  def cache_key
    self
      .class
      .name
      .underscore
      .to_sym
  end

  private

  def response_not_defined?
    context.token.nil?
  end

  def request_uri
    URI(client_url)
  end

  def retrieve_and_save_token
    response = api_call_with_error_handling

    token = access_token(response)

    handle_empty_token(token, response)

    cache.write(cache_key, token, expires_in: [expires_in(response).to_i - 10, 0].max)

    token
  end

  def handle_empty_token(token, _response)
    fail_to_request_provider!(ProviderUnknownError) if token.blank?
  end

  def token_from_cache
    cache.read(cache_key)
  end

  def cache
    @cache ||= EncryptedCache.instance
  end
end
