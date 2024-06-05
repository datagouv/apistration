require_relative '../provider_stubs'

module ProviderStubs::FranceConnectV2
  def mock_valid_france_connect_v2_checktoken(scopes: nil)
    scopes ||= minimal_france_connect_scopes

    scopes = scopes.join(' ') if scopes.is_a?(Array)

    stub_request(:post, Siade.credentials[:france_connect_v2_check_token_url]).to_return(
      status: 200,
      body: france_connect_v2_checktoken_payload(scopes:).to_json
    )
  end

  def mock_invalid_france_connect_v2_checktoken(kind = :expired_or_not_found)
    stub_request(:post, Siade.credentials[:france_connect_v2_check_token_url]).to_return(
      extract_france_connect_v2_checktoken_error(kind)
    )
  end

  # rubocop:disable Metrics/MethodLength
  def extract_france_connect_v2_checktoken_error(kind)
    case kind
    when :expired_or_not_found
      {
        status: 401,
        body: {
          status: 'fail',
          message: 'token_not_found_or_expired'
        }.to_json
      }
    when :malformed
      {
        status: 400,
        body: {
          status: 'fail',
          message: 'Malformed access token.'
        }.to_json
      }
    end
  end
  # rubocop:enable Metrics/MethodLength

  def france_connect_v2_checktoken_payload(scopes: nil)
    {
      aud: '423dcbdc5a15ece61ed00ff5989d72379c26d9ed4c8e4e05a87cffae019586e0',
      iat: 1_704_965_332,
      iss: 'https://auth.integ01.dev-franceconnect.fr/api/v2',
      token_introspection: token_introspection(scopes)
    }
  end

  # rubocop:disable Metrics/MethodLength
  def extract_france_connect_v2_checktoken_error(kind)
    case kind
    when :expired_or_not_found
      {
        status: 401,
        body: {
          error: 'invalid_client',
          error_message: 'Client authentication failed.'
        }.to_json
      }
    when :malformed
      {
        status: 400,
        body: {
          error: 'invalid_request',
          error_message: 'Required parameter missing or invalid.'
        }.to_json
      }
    end
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength
  def token_introspection(scopes)
    {
      active: true,
      aud: '6925fb8143c76eded44d32b40c0cb1006065f7f003de52712b78985704f39950',
      sub: '2fa48e3542c8645567f983efc96305808ae7d3f0d9cc4016ef40c3cde44844cfv1',
      iat: 1_704_965_328,
      exp: 1_704_965_388,
      acr: 'eidas2',
      jti: 'Wn5igB6_frAVBXQgShzI0znLE3fid2cWZHR9TWtqxZM',
      scope: scopes,
      gender: 'male',
      family_name: 'DUPONT',
      given_name: 'Jean Martin',
      given_name_array: %w[Jean Martin],
      birthdate: '2000-01-01',
      birthplace: '75101',
      birthcountry: '99100'
    }
  end
  # rubocop:enable Metrics/MethodLength
end
