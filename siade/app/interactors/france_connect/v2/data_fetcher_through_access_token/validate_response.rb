require 'jwe'
require 'jwt'
require 'net/http'
require 'uri'

class FranceConnect::V2::DataFetcherThroughAccessToken::ValidateResponse < FranceConnect::ValidateResponse
  def call
    handle_invalid_token_error if [400, 401].include?(http_code)
    unknown_provider_response! if [500].include?(http_code)

    if http_ok?
      fail_for_insufficient_privileges! unless scopes_include_hub_identity?

      return if scopes_include_hub_identity?
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
    JSON.parse(JWT.decode(context.jws, ecdsa_key, true, algorithm: decipher_algorithm).first)
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
end
