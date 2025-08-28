class SDH::StatutSportif::ValidateResponse < ValidateResponse
  def call
    resource_not_found! if http_not_found?

    return if http_ok?

    unknown_provider_response!
  end
end
