class JwtTokenService
  include Singleton

  DINUM_SIRET = '13002526500013'.freeze

  def extract_user(jwt_token)
    cached_token = cached_user(jwt_token)

    if cached_token.present?
      add_user_access_to_logger(cached_token)
      return cached_user(jwt_token)
    end

    decoded_token = decode_token(jwt_token)

    jwt_data = decoded_token.slice(:uid, :roles, :scopes, :jti, :iat, :exp, :mcp)

    jwt_data[:scopes] ||= jwt_data.delete(:roles) if jwt_data[:roles].present?

    jwt_data = enhance_jwt_data(jwt_data, decoded_token)

    jwt_user = build_and_cache_user!(jwt_token, jwt_data)

    add_user_access_to_logger(jwt_user)

    jwt_user
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    nil
  end

  private

  def cache
    EncryptedCache.instance
  end

  def add_user_access_to_logger(jwt_user)
    return if jwt_user.blank?

    ActiveSupport::Notifications.instrument(
      'user_access',
      user: jwt_user.logstash_id,
      jti: jwt_user.token_id,
      iat: jwt_user.iat
    )
  end

  def enhance_jwt_data(jwt_data, decoded_token)
    if internal_token?(decoded_token[:jti])
      enhanced_jwt_data_with_token_for_internal_token(jwt_data, decoded_token)
    else
      enhanced_jwt_data_with_token_from_database(jwt_data, decoded_token)
    end
  end

  def enhanced_jwt_data_with_token_for_internal_token(jwt_data, decoded_token)
    jwt_data[:scopes] = decoded_token[:scopes]
    jwt_data[:siret] = DINUM_SIRET

    jwt_data
  end

  def enhanced_jwt_data_with_token_from_database(jwt_data, decoded_token)
    token = extract_token_from_database!(decoded_token)

    jwt_data[:siret] = token.siret
    jwt_data[:scopes] = token.scopes
    jwt_data[:blacklisted] = token.blacklisted?
    jwt_data[:exp] = token.exp
    jwt_data[:mcp] = jwt_data[:mcp] || token.mcp

    enrich_with_security_settings(jwt_data, token)

    jwt_data
  end

  def enrich_with_security_settings(jwt_data, token)
    security_settings = token.authorization_request&.security_settings
    return unless security_settings

    jwt_data[:rate_limit_per_minute] = security_settings.rate_limit_per_minute
    jwt_data[:allowed_ips] = security_settings.allowed_ips
  end

  def build_and_cache_user!(jwt_token, jwt_data)
    user = JwtUser.new(**jwt_data)

    cache.write(jwt_token, user, expires_in: 1.hour)

    user
  end

  def cached_user(jwt_token)
    cache.read(jwt_token)
  end

  def internal_token?(jti)
    [
      JwtUser.debugger_id
    ].include?(jti)
  end

  def extract_token_from_database!(decoded_token)
    Token.find(decoded_token[:jti])
  end

  def decode_token(jwt_token)
    decoded_tokens = JWT.decode(jwt_token, hash_secret, true, { verify_expiration: false, algorithm: hash_algo })
    decoded_tokens.fetch(0).deep_symbolize_keys
  end

  def hash_secret
    Siade.credentials[:jwt_hash_secret]
  end

  def hash_algo
    Siade.credentials[:jwt_hash_algo]
  end
end
