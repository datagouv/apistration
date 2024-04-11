class CNAV::ValidateResponse < ValidateResponse
  def call
    resource_not_found! if http_not_found?
    unknown_provider_response! if !http_ok? || invalid_json?
  end

  protected

  def resource_not_found!
    fail_with_error!(build_error(::NotFoundError, 'Dossier allocataire inexistant. Le document ne peut être édité.'))
  end
end
