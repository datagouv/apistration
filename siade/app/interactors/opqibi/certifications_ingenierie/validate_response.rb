class OPQIBI::CertificationsIngenierie::ValidateResponse < ValidateResponse
  def call
    return if http_ok?

    resource_not_found!(:siren) if http_not_found?

    unknown_provider_response!
  end
end
