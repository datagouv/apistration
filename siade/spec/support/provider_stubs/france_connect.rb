# rubocop:disable Metrics/ModuleLength

require_relative '../provider_stubs'

module ProviderStubs::FranceConnect
  def mock_valid_france_connect_checktoken(scopes: nil)
    scopes ||= minimal_france_connect_scopes

    scopes = scopes.join(' ') if scopes.is_a?(Array)

    stub_request(:post, Siade.credentials[:france_connect_v2_check_token_url]).to_return(
      status: 200,
      body: france_connect_checktoken_payload(scopes:)
    )
  end

  def mock_invalid_france_connect_checktoken(kind = :expired_or_not_found)
    stub_request(:post, Siade.credentials[:france_connect_v2_check_token_url]).to_return(
      extract_france_connect_checktoken_error(kind)
    )
  end

  def france_connect_checktoken_payload(scopes: minimal_france_connect_scopes)
    stub_france_connect_jwks

    encrypt_payload(france_connect_decrypted_payload(scopes:))
  end

  def france_connect_checktoken_invalid_payload
    stub_france_connect_jwks

    encrypt_payload(france_connect_decrypted_invalid_payload)
  end

  def france_connect_checktoken_invalid_parameter_payload
    stub_france_connect_jwks

    encrypt_payload(france_connect_decrypted_invalid_parameter_payload)
  end

  def france_connect_decrypted_invalid_payload
    {
      aud: '423dcbdc5a15ece61ed00ff5989d72379c26d9ed4c8e4e05a87cffae019586e0',
      iat: 1_704_965_332,
      iss: 'https://auth.integ01.dev-franceconnect.fr/api/v2',
      token_introspection: {
        active: false
      }
    }
  end

  def france_connect_decrypted_invalid_parameter_payload(scopes: minimal_france_connect_scopes)
    {
      aud: '423dcbdc5a15ece61ed00ff5989d72379c26d9ed4c8e4e05a87cffae019586e0',
      iat: 1_704_965_332,
      iss: 'https://auth.integ01.dev-franceconnect.fr/api/v2',
      token_introspection: token_introspection(scopes).except(:family_name)
    }
  end

  def france_connect_decrypted_payload(scopes: minimal_france_connect_scopes)
    {
      aud: '423dcbdc5a15ece61ed00ff5989d72379c26d9ed4c8e4e05a87cffae019586e0',
      iat: 1_704_965_332,
      iss: 'https://auth.integ01.dev-franceconnect.fr/api/v2',
      token_introspection: token_introspection(scopes)
    }
  end

  # rubocop:disable Metrics/MethodLength
  def extract_france_connect_checktoken_error(kind)
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

  def default_france_connect_identity_attributes
    {
      given_name: 'Jean Martin',
      given_name_array: %w[Jean Martin],
      family_name: 'DUPONT',
      birthdate: france_connect_default_birthdate,
      gender: 'male',
      birthplace: '75101',
      birthcountry: '99100',
      preferred_username: nil
    }
  end

  def france_connect_default_birthdate
    "#{Time.zone.today.year - 20}-01-01"
  end
  # rubocop:enable Metrics/MethodLength

  def token_introspection(scopes)
    {
      active: true,
      aud: '6925fb8143c76eded44d32b40c0cb1006065f7f003de52712b78985704f39950',
      sub: '2fa48e3542c8645567f983efc96305808ae7d3f0d9cc4016ef40c3cde44844cfv1',
      iat: 1_704_965_328,
      exp: 1_704_965_388,
      acr: 'eidas2',
      jti: 'wn5igb6_fravbxqgshzi0znle3fid2cwzhr9twtqxzm',
      scope: scopes
    }.merge(default_france_connect_identity_attributes)
  end

  def ecdsa_key
    @ecdsa_key ||= OpenSSL::PKey::EC.generate(Siade.credentials[:france_connect_v2_signing_algorithm])
  end

  def stub_france_connect_jwks
    stub_request(:get, Siade.credentials[:france_connect_v2_jwks_url]).to_return(
      status: 200,
      body: jwks.to_json
    )
  end

  def jwks
    jwk = JWT::JWK.new(ecdsa_key)
    # Build JWKS
    {
      keys: [
        jwk.export.merge({ use: 'sig', alg: 'ES256' })
      ]
    }
  end

  def encrypt_payload(payload)
    JWE.encrypt(
      JWT.encode(payload, ecdsa_key, Siade.credentials[:france_connect_v2_decipher_algorithm]),
      OpenSSL::PKey::RSA.new(Siade.credentials[:france_connect_v2_rsa_public]),
      alg: 'RSA-OAEP',
      enc: 'A256GCM'
    )
  end

  def minimal_france_connect_scopes
    'openid identite_pivot'
  end
end
# rubocop:enable Metrics/ModuleLength
