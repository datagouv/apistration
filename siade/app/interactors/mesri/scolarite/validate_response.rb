class MESRI::Scolarite::ValidateResponse < ValidateResponse
  def call
    provider_timeout_error! if http_provider_timeout_error?

    # provider_bad_gateway_error! if http_provider_bad_gateway_error? #TODO: n'existe pas dans SIADE?

    provider_internal_error! if http_internal_error?

    return if http_ok?

    unknown_provider_response!
  end
end
