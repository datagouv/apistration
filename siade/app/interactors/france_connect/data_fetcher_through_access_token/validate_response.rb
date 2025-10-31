require 'jwe'
require 'jwt'
require 'net/http'
require 'uri'

class FranceConnect::DataFetcherThroughAccessToken::ValidateResponse < FranceConnect::ValidateResponse
  def call
    handle_invalid_token_error if [400, 401].include?(http_code)
    unknown_provider_response! if [500].include?(http_code)

    if http_ok?
      track_france_connect_response! if Rails.env.staging?
      fail_for_token_expired! unless token_valid?

      fail_if_unprocessable_params_in_response!

      return if token_valid?
    end

    unknown_provider_response!
  end

  protected

  def error?
    context.json_body.present? && context.json_body['error'].present?
  end

  def json_body
    unless error?
      context.jws = decipher_response
      context.json_body = verify_jws
    end

    context.json_body
  end

  def verify_jws
    JWT.decode(context.jws, ecdsa_key, true, algorithm: decipher_algorithm).first
  end

  def decipher_response
    JWE.decrypt(context.response.body, rsa_private_key)
  end

  def scopes
    json_body['token_introspection']['scope'].split
  end

  def handle_invalid_token_error
    case error_type
    when 'invalid_request'
      fail_with_error!(InvalidFranceConnectAccessTokenError.new(:malformed_token))
    when 'invalid_client'
      fail_with_error!(InvalidFranceConnectAccessTokenError.new(:not_found_or_expired))
    else
      unknown_provider_response!
    end
  end

  def error_type
    JSON.parse(context.response.body)['error']
  end

  def params_to_verify # rubocop:disable Metrics/AbcSize
    {
      nom_naissance: json_body['token_introspection']['family_name'],
      prenoms: json_body['token_introspection']['given_name_array'],
      annee_date_naissance: json_body['token_introspection']['birthdate']&.split('-')&.first,
      mois_date_naissance: json_body['token_introspection']['birthdate']&.split('-')&.second,
      jour_date_naissance: json_body['token_introspection']['birthdate']&.split('-')&.third
    }
  end

  private

  def rsa_private_key
    OpenSSL::PKey::RSA.new(Siade.credentials[:france_connect_v2_rsa_private])
  end

  def decipher_algorithm
    Siade.credentials[:france_connect_v2_decipher_algorithm]
  end

  def ecdsa_key
    uri = URI(Siade.credentials[:france_connect_v2_jwks_url])

    response = Net::HTTP.get_response(uri)

    if response.code == '200'
      JSON.parse(response.body)['keys'].each do |key|
        next unless key['use'] == 'sig' && key['kty'] == 'EC'

        return JWT::JWK.import(key).public_key
      end
    end

    raise unknown_provider_response!
  end

  def fail_for_token_expired!
    fail_with_error!(InvalidFranceConnectAccessTokenError.new(:not_found_or_expired))
  end

  def track_france_connect_response!
    MonitoringService.instance.track_with_added_context(
      'info',
      'FranceConnect v2 response',
      {
        json_body:
      }
    )
  end

  def token_valid?
    json_body['token_introspection']['active']
  end
end
