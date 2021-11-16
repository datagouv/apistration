class DGDDI::EORI::ValidateResponse < ValidateResponse
  def call
    return if http_ok?

    if http_not_found?
      resource_not_found!
    else
      unknown_provider_response!
    end
  end
end
