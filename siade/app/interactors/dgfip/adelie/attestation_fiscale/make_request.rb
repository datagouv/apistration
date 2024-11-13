class DGFIP::ADELIE::AttestationFiscale::MakeRequest < DGFIP::ADELIE::MakeRequest
  def request_params
    common_request_params.merge(
      siren: context.params[:siren],
      groupeIS: 'NON',
      groupeTVA: 'NON'
    )
  end

  def extra_http_start_options
    {
      open_timeout: 15,
      read_timeout: 15
    }
  end

  def request_uri
    URI("#{base_url}/attestationFiscale")
  end
end
