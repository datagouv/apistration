class JwtUser
  attr_reader :id, :jti, :scopes, :iat, :siret, :exp, :mcp,
    :rate_limit_per_minute, :allowed_ips, :editor_id,
    :authorization_request_id

  def self.debugger_id
    '00000000-0000-0000-0000-000000000000'
  end

  def self.france_connect_id
    '11111111-1111-1111-1111-111111111111'
  end

  def initialize(uid:, scopes:, jti:, iat:, exp: nil, blacklisted: false, siret: nil, mcp: false,
                 rate_limit_per_minute: nil, allowed_ips: nil, editor_id: nil,
                 authorization_request_id: nil)
    @id = uid
    @scopes = scopes
    @jti = jti
    @iat = Time.zone.at iat
    @exp = exp
    @blacklisted = blacklisted
    @siret = siret
    @mcp = mcp
    @rate_limit_per_minute = rate_limit_per_minute
    @allowed_ips = allowed_ips
    @editor_id = editor_id
    @authorization_request_id = authorization_request_id
  end

  def editor?
    @editor_id.present?
  end

  def with_delegation(authorization_request_id:, scopes:, allowed_ips:, rate_limit_per_minute:)
    self.class.new(
      uid: id,
      jti:,
      scopes:,
      iat: iat.to_i,
      exp:,
      blacklisted: blacklisted?,
      siret:,
      mcp: mcp?,
      editor_id:,
      authorization_request_id:,
      allowed_ips:,
      rate_limit_per_minute:
    )
  end

  def ip_allowed?(request_ip)
    IpWhitelist.allowed?(allowed_ips, request_ip)
  end

  def has_custom_rate_limit?
    rate_limit_per_minute.present?
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

  def blacklisted?
    @blacklisted
  end

  def mcp?
    @mcp
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

  def scope?(scope_name)
    @scopes.include?(scope_name.to_s)
  end

  def one_of_scopes?(scopes)
    scopes.any? { |scope| scope?(scope) }
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
