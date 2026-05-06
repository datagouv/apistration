class INSEE::MakeRequest < MakeRequest::Get
  ROTATION_LOCK_KEY = 'insee/password_rotation_lock'.freeze
  ROTATION_LOCK_TTL = 30

  def call
    super

    rotate_password_if_needed!
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

  def rotate_password_if_needed!
    return unless password_rotation_needed?

    return unless acquire_rotation_lock!

    renew_context = INSEE::RenewPassword.call(
      token: context.token,
      old_password: INSEE::PasswordDerivation.previous_password,
      new_password: INSEE::PasswordDerivation.current_password,
      provider_name: context.provider_name
    )

    INSEE::Authenticate.invalidate_token_cache! if renew_context.success?
  end

  def password_rotation_needed?
    return false if context.token.blank?
    return false if INSEE::PasswordDerivation.current_period < INSEE::PasswordDerivation::DERIVATION_START

    pwd_changed_period = pwd_changed_period_from_token
    return false if pwd_changed_period.nil?

    pwd_changed_period < INSEE::PasswordDerivation.current_period
  end

  def pwd_changed_period_from_token
    payload = JWT.decode(context.token, nil, false).first
    pwd_changed_time = payload['pwdChangedTime']
    return if pwd_changed_time.nil?

    date = Time.zone.parse(pwd_changed_time).to_date
    INSEE::PasswordDerivation.send(:period_for, date)
  rescue JWT::DecodeError
    nil
  end

  def acquire_rotation_lock!
    rotation_redis.set(ROTATION_LOCK_KEY, Process.pid, nx: true, ex: ROTATION_LOCK_TTL)
  end

  def rotation_redis
    @rotation_redis ||= RedisService.new
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
