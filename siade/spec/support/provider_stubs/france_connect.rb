require_relative '../provider_stubs'

module ProviderStubs::FranceConnect
  def mock_valid_france_connect_checktoken(scopes: nil)
    mock_valid_france_connect_v2_checktoken(scopes:)
  end

  def mock_invalid_france_connect_checktoken(kind = :expired_or_not_found)
    mock_invalid_france_connect_v2_checktoken(kind)
  end

  def france_connect_checktoken_payload(scopes: nil)
    france_connect_v2_checktoken_payload(scopes:)
  end

  def default_france_connect_identity_attributes
    default_france_connect_v2_identity_attributes
  end

  def minimal_france_connect_scopes
    'openid identite_pivot'
  end
end
