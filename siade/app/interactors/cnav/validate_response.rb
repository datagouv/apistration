class CNAV::ValidateResponse < ValidateResponse
  def call
    resource_not_found! if http_not_found?
    handle_http_too_many_requests! if http_too_many_requests?
    unknown_provider_response! if !http_ok? || invalid_json?
  end

  protected

  def handle_http_too_many_requests!
    fail_with_error!(build_error(ProviderRateLimitingError))
  end

  def resource_not_found!
    error = build_error(::NotFoundError, 'Dossier allocataire inexistant. Le document ne peut être édité.')

    fail_with_error!(error)
  end
end
