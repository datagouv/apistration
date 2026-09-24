class InvalidFranceConnectAccessTokenError < AbstractSpecificProviderError
  def self.build_example(type:, **)
    new(type)
  end

  attr_reader :scopes

  def initialize(type, scopes: [])
    super(type)

    @scopes = scopes
  end

  def type
    @kind
  end

  def provider_name
    'FranceConnect'
  end

  def title
    'Accès non autorisé'
  end

  def kind
    :unauthorized
  end

  def detail
    return super unless type == :missing_hub_identity_scope

    "#{super} Le jeton possède les scopes suivants: #{scopes.join(', ')}."
  end

  protected

  def subcode_config
    {
      malformed_token: '501',
      not_found_or_expired: '502',
      missing_hub_identity_scope: '503',
      missing_france_connect_access_token: '504'
    }
  end
end
