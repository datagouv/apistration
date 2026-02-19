class INPI::RNE::Company::ValidateResponse < ValidateResponse
  def call
    resource_not_found! if http_not_found?
    provider_unavailable! if http_ok? && invalid_json?
    return if http_ok?

    rate_limited! if http_too_many_requests?

    unknown_provider_response!
  end
end
