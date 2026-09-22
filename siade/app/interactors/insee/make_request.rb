class INSEE::MakeRequest < MakeRequest::Get
  REJECTED_BEARER_MESSAGE = 'INSEE rejected the bearer, reauthenticating'.freeze
  REJECTED_BEARER_CACHE_KEY = 'insee/rejected_bearer'.freeze
  REJECTED_BEARER_REPORT_INTERVAL = 5.minutes

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

    report_rejected_bearer!

    reauthenticate!

    api_call_with_error_handling
    fail_with_temporary_auth_error! if token_expired_response?
  end

  def report_rejected_bearer!
    already_reported = Rails.cache.write(
      REJECTED_BEARER_CACHE_KEY,
      true,
      expires_in: REJECTED_BEARER_REPORT_INTERVAL,
      unless_exist: true
    ) == false

    return if already_reported

    MonitoringService.instance.track('warning', REJECTED_BEARER_MESSAGE)
  end

  def reauthenticate!
    INSEE::Authenticate.invalidate_token_cache!(context.token)

    auth_context = INSEE::Authenticate.call(provider_name: context.provider_name)

    unless auth_context.success?
      context.errors.concat(auth_context.errors)
      context.fail!
    end

    context.token = auth_context.token
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
