class JwtTokenService
  def initialize(jwt_token)
    @jwt_token = jwt_token
  end

  def extract_user
    jwt_data = decoded_token.slice(:uid, :roles, :scopes, :jti, :iat, :exp)

    jwt_data[:scopes] = jwt_data.delete(:roles) if jwt_data[:roles]

    JwtUser.new(**jwt_data)
  rescue JWT::DecodeError
    nil
  end

  def decoded_token
    @decoded_token ||= begin
      decoded_tokens = JWT.decode(@jwt_token, hash_secret, true, { verify_expiration: false, algorithm: hash_algo })
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
