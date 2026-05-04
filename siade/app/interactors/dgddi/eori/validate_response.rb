class DGDDI::EORI::ValidateResponse < ValidateResponse
  declares_no_specific_errors!

  def call
    return if http_ok?

    if http_not_found?
      resource_not_found!
    else
      unknown_provider_response!
    end
  end
end
