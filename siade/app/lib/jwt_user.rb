class JwtUser
  attr_reader :id, :jti, :roles, :iat

  def initialize(uid:, roles:, jti:, iat:, exp: nil)
    @id = uid
    @roles = roles
    @jti = jti
    @iat = Time.zone.at iat
    @exp = exp
  end

  def has_access?(role)
    @roles.include?(role)
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

  def expired?
    if @exp.nil?
      ::MonitoringService.instance.track('info', "JWT #{logstash_id.inspect} without Expiration Time")

      return false
    end

    ::Time.zone.at(@exp).past?
  end
end
