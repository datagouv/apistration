class InvalidFranceConnectAccessTokenError < UnauthorizedError
  attr_reader :type

  def initialize(type)
    @type = type.to_sym
  end

  def title
    'Accès non autorisé'
  end

  def code
    {
      malformed_token: '50001',
      not_found_or_expired: '50002',
      missing_hub_identity_scope: '50003'
    }.fetch(type) do
      raise KeyError, "#{type} is not a valid field name"
    end
  end
end
