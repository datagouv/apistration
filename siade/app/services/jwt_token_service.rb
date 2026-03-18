class JwtTokenService
  include ActiveModel::Model

  attr_accessor :jwt

  validates_format_of :jwt, with: /\A([a-zA-Z0-9_-]+\.){2}([a-zA-Z0-9_-]+)?\z/

  def jwt_user
    @jwt_user ||= decode_jwt
  end

  private

  def decode_jwt
    return nil if invalid?

    JwtUser.new(decoded_token)
  rescue JWT::DecodeError
    nil
  end

  def decoded_token
    @_decoded_token_cache ||= compute_decoded_token
  end

  def compute_decoded_token
    decoded_tokens = JWT.decode(@jwt, hash_secret, true, { verify_expiration: false, algorithm: hash_algo })
    decoded_tokens.fetch(0).deep_symbolize_keys
  end

  def hash_secret
    Siade.credentials[:jwt_hash_secret]
  end

  def hash_algo
    Siade.credentials[:jwt_hash_algo]
  end
end
