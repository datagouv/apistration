class DGFIP::AttestationFiscale::MakeRequest < DGFIP::AbstractMakeRequest
  protected

  def set_headers(request)
    request['Accept'] = 'application/pdf'
    request['Cookie'] = context.cookie
  end

  def mocking_params
    {
      siren:
    }
  end

  def timeout_http_options
    {
      open_timeout: 15,
      read_timeout: 15
    }
  end

  def request_uri
    URI(Siade.credentials[:dgfip_attestations_fiscales_url])
  end

  def request_params
    {
      userId: user_id_sanitized,
      siren:,
      groupeIS: 'NON',
      groupeTVA: 'NON'
    }
  end

  private

  def siren
    params[:siren]
  end
end
