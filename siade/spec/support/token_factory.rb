require 'jwt'

class TokenFactory
  attr_reader :scopes

  def initialize(scopes = nil)
    @scopes = Array(scopes).map(&:to_s) || []
  end

  def valid(uid: default_uid, mcp: false)
    encode(payload(uid:, mcp:))
  end

  def expired(uid: default_uid)
    encode(payload(uid:, exp: 1.year.ago.to_i))
  end

  def payload(uid: default_uid, exp: 1.year.from_now.to_i, mcp: false)
    {
      uid:,
      jti: uid,
      scopes:,
      sub: 'whatever',
      version: '1.0',
      iat: 1.year.ago.to_i,
      exp:,
      mcp:
    }
  end

  private

  def default_uid
    JwtUser.debugger_id
  end

  def encode(payload)
    JWT.encode(payload, hash_secret, hash_algo)
  end

  def hash_secret
    Siade.credentials[:jwt_hash_secret]
  end

  def hash_algo
    Siade.credentials[:jwt_hash_algo]
  end
end
