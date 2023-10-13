class CNAF::QuotientFamilialV2::ValidateResponse < ValidateResponse
  def call
    resource_not_found! if http_not_found?
    unknown_provider_response! if !http_ok? || invalid_json?
  end

  protected

  def resource_not_found!
    error = build_error(::NotFoundError, 'Dossier allocataire inexistant. Le document ne peut être édité.')

    add_monitoring_private_context(error)

    fail_with_error!(error)
  end
end
