class FNTP::CarteProfessionnelleTravauxPublics::ValidateResponse < ValidateResponse
  def call
    resource_not_found!(:siret_or_siren) if http_not_found?
    internal_server_error! if http_internal_error?

    return if http_ok?

    unknown_provider_response!
  end
end
