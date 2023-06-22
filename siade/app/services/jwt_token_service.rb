class JwtTokenService
  attr_reader :jwt_token

  def initialize(jwt_token)
    @jwt_token = jwt_token
  end

  def extract_user
    return cached_user if cached_user.present?

    jwt_data = decoded_token.slice(:uid, :roles, :jti, :iat, :exp)

    if special_token?
      jwt_data[:scopes] = decoded_token[:scopes]
    else
      jwt_data = enhanced_jwt_data_with_token(jwt_data)
    end

    build_and_cache_user!(jwt_data)
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    nil
  end

  def jwt_id
    decoded_token[:jti]
  end

  private

  def cache
    EncryptedCache.instance
  end

  def enhanced_jwt_data_with_token(jwt_data)
    token = extract_token_from_database!

    jwt_data[:scopes] = token.scopes
    jwt_data[:blacklisted] = token.blacklisted?

    jwt_data
  end

  def build_and_cache_user!(jwt_data)
    user = JwtUser.new(**jwt_data)

    cache.write(jwt_token, user, expires_in: 1.hour)

    user
  end

  def cached_user
    cache.read(jwt_token)
  end

  def special_token?
    [
      JwtUser.uptime_id,
      JwtUser.debugger_id
    ].include?(decoded_token[:jti])
  end

  def extract_token_from_database!
    Token.find(jwt_id)
  end

  def decoded_token
    @decoded_token ||= begin
      decoded_tokens = JWT.decode(jwt_token, hash_secret, true, { verify_expiration: false, algorithm: hash_algo })
      decoded_tokens.fetch(0).deep_symbolize_keys
    end
  end

  def hash_secret
    Siade.credentials[:jwt_hash_secret]
  end

  def hash_algo
    Siade.credentials[:jwt_hash_algo]
  end
end
