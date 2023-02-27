class JwtUser
  attr_reader :id, :jti, :scopes, :iat

  def initialize(uid:, scopes:, jti:, iat:, exp: nil)
    @id = uid
    @scopes = scopes
    @jti = jti
    @iat = Time.zone.at iat
    @exp = exp
  end

  def has_access?(scope)
    @scopes.include?(scope)
  end

  def logstash_id
    @id
  end

  def token_id
    @jti
  end

  def not_expired!
    raise ::JWT::ExpiredSignature if expired?

    self
  end

  def valid?
    jti =~ uuid_regex &&
      id =~ uuid_regex
  end

  def invalid?
    !valid?
  end

  def expired?
    if @exp.nil?
      ::MonitoringService.instance.track('info', "JWT #{logstash_id.inspect} without Expiration Time")

      return false
    end

    ::Time.zone.at(@exp).past?
  end

  private

  def uuid_regex
    /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
  end
end
