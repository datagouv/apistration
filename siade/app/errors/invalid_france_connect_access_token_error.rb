class InvalidFranceConnectAccessTokenError < UnauthorizedError
  attr_reader :type, :scopes

  def initialize(type, scopes: [])
    @type = type.to_sym
    @scopes = scopes
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

  def detail
    if type == :missing_hub_identity_scope
      super + " Le jeton possède les scopes suivants: #{scopes.join(', ')}."
    else
      super
    end
  end
end
