class SDH::StatutSportif::ValidateResponse < ValidateResponse
  declares_no_specific_errors!

  def call
    resource_not_found! if http_not_found?

    return if http_ok?

    unknown_provider_response!
  end
end
