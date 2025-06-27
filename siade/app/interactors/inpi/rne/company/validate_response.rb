class INPI::RNE::Company::ValidateResponse < ValidateResponse
  def call
    resource_not_found! if http_not_found?
    unknown_provider_response! if http_ok? && invalid_json?
    return if http_ok?

    unknown_provider_response!
  end
end
