require 'jwt'

class TokenFactory
  attr_reader :scopes

  def initialize(scopes = nil)
    @scopes = Array(scopes).map(&:to_s) || []
  end

  def valid(uid: nil)
    JWT.encode(payload(uid:), hash_secret, hash_algo)
  end

  private

  def payload(uid:)
    {
      uid: uid || SecureRandom.uuid,
      jti: uid || SecureRandom.uuid,
      scopes:,
      sub: 'whatever',
      version: '1.0',
      iat: 1.year.ago.to_i,
      exp: 1.year.from_now.to_i
    }
  end

  def hash_secret
    Siade.credentials[:jwt_hash_secret]
  end

  def hash_algo
    Siade.credentials[:jwt_hash_algo]
  end
end
