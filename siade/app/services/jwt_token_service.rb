class JwtTokenService
  include Singleton

  DINUM_SIRET = '13002526500013'.freeze
  STAGING_TOKEN_SUBJECT = 'staging'.freeze
  STAGING_TOKEN_JTI = '00000000-0000-0000-0000-000000000000'.freeze

  class ExtractionError < StandardError
    attr_reader :reason

    def initialize(reason)
      @reason = reason
      super(reason.to_s)
    end
  end

  def extract_user(jwt_token)
    cached_token = cached_user(jwt_token)
    return cached_token if cached_token.present?

    decoded_token = decode_token(jwt_token)

    jwt_data = decoded_token.slice(:uid, :roles, :scopes, :jti, :iat, :exp, :mcp)

    jwt_data[:scopes] ||= jwt_data.delete(:roles) if jwt_data[:roles].present?

    jwt_data = enhance_jwt_data(jwt_data, decoded_token)

    build_and_cache_user!(jwt_token, jwt_data)
  rescue JWT::VerificationError
    raise ExtractionError, invalid_signature_reason(jwt_token)
  rescue JWT::DecodeError
    raise ExtractionError, :malformed
  rescue ActiveRecord::RecordNotFound
    raise ExtractionError, :not_found
  end

  private

  def cache
    EncryptedCache.instance
  end

  def enhance_jwt_data(jwt_data, decoded_token)
    if decoded_token[:editor]
      enhanced_jwt_data_for_editor_token(jwt_data, decoded_token)
    elsif internal_token?(decoded_token[:jti])
      enhanced_jwt_data_with_token_for_internal_token(jwt_data, decoded_token)
    else
      enhanced_jwt_data_with_token_from_database(jwt_data, decoded_token)
    end
  end

  def enhanced_jwt_data_for_editor_token(jwt_data, decoded_token)
    editor_token = EditorToken.find(decoded_token[:jti])
    editor = editor_token.editor

    jwt_data[:scopes] = []
    jwt_data[:blacklisted] = editor_token.blacklisted?
    jwt_data[:exp] = editor_token.exp
    jwt_data[:editor_id] = editor.id

    jwt_data
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
    jwt_data[:authorization_request_id] = token.authorization_request_model_id

    enrich_with_security_settings(jwt_data, token)

    jwt_data
  end

  def enrich_with_security_settings(jwt_data, token)
    security_settings = token.authorization_request&.security_settings
    return unless security_settings

    jwt_data[:rate_limit_per_minute] = security_settings.rate_limit_per_minute
    jwt_data[:allowed_ips] = security_settings.allowed_ips
    jwt_data[:throttle_overrides] = security_settings.throttle_overrides
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

  def invalid_signature_reason(jwt_token)
    payload = unverified_payload(jwt_token)
    return :invalid_signature if payload.nil?

    staging_token = staging_token?(payload)

    if Rails.env.staging? && !staging_token
      :production_token_on_staging
    elsif Rails.env.production? && staging_token
      :staging_token_on_production
    else
      :invalid_signature
    end
  end

  def unverified_payload(jwt_token)
    JWT.decode(jwt_token, nil, false).fetch(0)
  rescue JWT::DecodeError
    nil
  end

  def staging_token?(payload)
    payload['sub'] == STAGING_TOKEN_SUBJECT || payload['jti'] == STAGING_TOKEN_JTI
  end

  def hash_secret
    Siade.credentials[:jwt_hash_secret]
  end

  def hash_algo
    Siade.credentials[:jwt_hash_algo]
  end
end
