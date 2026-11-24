class OPQIBI::CertificationsIngenierie::ValidateResponse < ValidateResponse
  declares_no_specific_errors!

  def call
    return if http_ok?

    resource_not_found!(:siren) if http_not_found?

    internal_server_error! if http_internal_error?

    unknown_provider_response!
  end
end
