require_relative '../provider_stubs'

module ProviderStubs::FranceConnect
  def mock_valid_france_connect_checktoken(scopes: nil)
    scopes ||= minimal_france_connect_scopes

    stub_request(:post, Siade.credentials[:france_connect_sandbox_check_token_url]).to_return(
      status: 200,
      body: france_connect_checktoken_payload(scopes:).to_json
    )
  end

  def mock_invalid_france_connect_checktoken
    stub_request(:post, Siade.credentials[:france_connect_sandbox_check_token_url]).to_return(
      status: 401,
      body: {
        status: 'fail',
        message: 'token_not_found_or_expired'
      }.to_json
    )
  end

  def france_connect_checktoken_payload(scopes: nil)
    {
      scope: scopes,
      identity: default_france_connect_identity_attributes,
      client: france_connect_client_attributes
    }
  end

  def default_france_connect_identity_attributes
    {
      given_name: 'Jean Martin',
      family_name: 'DUPONT',
      birthdate: '2000-01-01',
      gender: 'male',
      birthplace: '75101',
      birthcountry: '99100',
      preferred_username: 'jdupont'
    }
  end

  def minimal_france_connect_scopes
    %w[
      openid
      identite_pivot
    ]
  end

  private

  def france_connect_client_attributes
    {
      client_id: '8436aea4c123456789876543234567812d76e0a24f633f8642016a44a189cdfd',
      client_name: 'Test app'
    }
  end
end
