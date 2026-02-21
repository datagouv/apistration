class INSEE::MakeRequest < MakeRequest::Get
  def call
    super

    retry_with_new_token! if should_retry_with_new_token?
  end

  protected

  def extra_headers(request)
    request['Authorization'] = "Bearer #{token}"
    super
  end

  def extra_http_start_options
    {
      open_timeout: 2,
      read_timeout: 2
    }
  end

  def token
    context.token
  end

  def sirene_base_path
    'api-sirene/prive/3.11'
  end

  def base_uri
    Siade.credentials[:insee_sirene_url]
  end

  private

  def should_retry_with_new_token?
    token_expired_response? && !context.token_refresh_attempted
  end

  def token_expired_response?
    context.response&.code&.to_i == 401
  end

  def retry_with_new_token!
    context.token_refresh_attempted = true

    fresh_token = EncryptedCache.read(INSEE::Authenticate::CACHE_KEY)
    if fresh_token && fresh_token != context.token
      context.token = fresh_token
    else
      authenticate_with_retries!
    end

    api_call_with_error_handling
    fail_with_temporary_auth_error! if token_expired_response?
  end

  def authenticate_with_retries!
    INSEE::Authenticate.invalidate_token_cache!

    max_auth_attempts = 5

    max_auth_attempts.times do |attempt|
      auth_context = INSEE::Authenticate.call(provider_name: context.provider_name)

      if auth_context.success?
        context.token = auth_context.token
        break
      end

      fail_with_temporary_auth_error! if attempt == max_auth_attempts - 1
      sleep(0.2)
    end
  end

  def fail_with_temporary_auth_error!
    error = ProviderTemporaryError.new(
      context.provider_name,
      "Erreur d'authentification temporaire auprès de l'INSEE, merci de réessayer votre appel"
    )
    error.add_meta(retry_in: 10)
    context.errors << error
    context.fail!
  end
end
