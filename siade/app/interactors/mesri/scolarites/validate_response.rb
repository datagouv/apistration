class MESRI::Scolarites::ValidateResponse < ValidateResponse
  def call
    provider_timeout_error! if http_provider_timeout_error?

    provider_bad_gateway_error! if http_provider_bad_gateway_error?

    provider_internal_error! if http_internal_error?

    resource_not_found! if http_not_found?

    return if http_ok?

    unknown_provider_response!
  end
end
