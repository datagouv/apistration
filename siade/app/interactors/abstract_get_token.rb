class AbstractGetToken < MakeRequest::Post
  MAX_AUTH_ATTEMPTS = 5
  AUTH_RETRY_DELAY = 0.2

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
    @auth_attempt_count ||= 0

    response = api_call_with_error_handling

    token = access_token(response)

    alternative_token = handle_empty_token(token, response)

    final_token = alternative_token || token

    save_token_to_cache(final_token, response) unless alternative_token

    final_token
  rescue JSON::ParserError
    @auth_attempt_count += 1

    if @auth_attempt_count < MAX_AUTH_ATTEMPTS
      sleep(AUTH_RETRY_DELAY)
      retry
    end

    fail_with_non_json_auth_response!(response)
  end

  def fail_with_non_json_auth_response!(response)
    error = ProviderUnknownError.new(context.provider_name)

    error.add_to_monitoring_private_context({
      http_response_code: response.code,
      http_response_body: response.body,
      http_response_headers: response.to_hash
    })

    context.errors << error
    context.fail!
  end

  def save_token_to_cache(token, response)
    cache.write(cache_key, token, expires_in: [expires_in(response).to_i - 10, 0].max)
  end

  def handle_empty_token(token, response)
    return if token.present?

    error = ProviderUnknownError.new(context.provider_name)

    error.add_to_monitoring_private_context({
      http_response_code: response.code,
      http_response_body: response.body,
      http_response_headers: response.to_hash
    })

    context.errors << error
    context.fail!
  end

  def token_from_cache
    cache.read(cache_key)
  end

  def cache
    @cache ||= EncryptedCache.instance
  end
end
