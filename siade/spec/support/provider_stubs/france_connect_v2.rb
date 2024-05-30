require_relative '../provider_stubs'

module ProviderStubs::FranceConnectV2
  def france_connect_v2_checktoken_payload
    {
      aud: '423dcbdc5a15ece61ed00ff5989d72379c26d9ed4c8e4e05a87cffae019586e0',
      iat: 1_704_965_332,
      iss: 'https://auth.integ01.dev-franceconnect.fr/api/v2',
      token_introspection:
    }
  end

  # rubocop:disable Metrics/MethodLength
  def token_introspection
    {
      active: true,
      aud: '6925fb8143c76eded44d32b40c0cb1006065f7f003de52712b78985704f39950',
      sub: '2fa48e3542c8645567f983efc96305808ae7d3f0d9cc4016ef40c3cde44844cfv1',
      iat: 1_704_965_328,
      exp: 1_704_965_388,
      acr: 'eidas2',
      jti: 'Wn5igB6_frAVBXQgShzI0znLE3fid2cWZHR9TWtqxZM',
      scope: %w[openid identite_pivot],
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
