require 'jwe'

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

  def json_body
    context.json_body ||= decipher_response
  end

  def decipher_response
    JSON.parse(JWE.decrypt(context.response.body, rsa_private_key))
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
end
