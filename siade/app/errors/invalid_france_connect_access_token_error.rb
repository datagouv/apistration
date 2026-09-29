class InvalidFranceConnectAccessTokenError < AbstractSpecificProviderError
  def self.build_example(type:, **)
    new(type)
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

  protected

  def subcode_config
    {
      malformed_token: '501',
      not_found_or_expired: '502',
      missing_france_connect_access_token: '504'
    }
  end
end
