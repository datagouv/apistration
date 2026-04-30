class OPQIBI::CertificationsIngenierie::ValidateResponse < ValidateResponse
  declares_no_specific_errors!

  def call
    return if http_ok?

    resource_not_found!(:siren) if http_not_found?

    unknown_provider_response!
  end
end
