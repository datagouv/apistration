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
      INSEE::Authenticate.invalidate_token_cache!
      INSEE::Authenticate.call!(context)
    end

    api_call_with_error_handling
  end
end
