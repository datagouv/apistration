class INPI::RNE::Download::ValidateResponse < ValidateResponse
  def call
    return if http_ok?

    resource_not_found! if http_not_found?

    unknown_provider_response!
  end
end
