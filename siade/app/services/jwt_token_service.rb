class JwtTokenService
  DINUM_SIRET = '13002526500013'.freeze

  attr_reader :jwt_token

  def initialize(jwt_token)
    @jwt_token = jwt_token
  end

  def extract_user
    return cached_user if cached_user.present?

    jwt_data = decoded_token.slice(:uid, :roles, :scopes, :jti, :iat, :exp)

    jwt_data[:scopes] ||= jwt_data.delete(:roles) if jwt_data[:roles].present?

    jwt_data = if internal_token?
                 enhanced_jwt_data_with_token_for_internal_token(jwt_data, decoded_token)
               else
                 enhanced_jwt_data_with_token_from_database(jwt_data)
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

  def enhanced_jwt_data_with_token_for_internal_token(jwt_data, decoded_token)
    jwt_data[:scopes] = decoded_token[:scopes]
    jwt_data[:siret] = DINUM_SIRET

    jwt_data
  end

  def enhanced_jwt_data_with_token_from_database(jwt_data)
    token = extract_token_from_database!

    jwt_data[:siret] = token.siret
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

  def internal_token?
    [
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
