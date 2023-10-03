class CarifOref::CertificationsQualiopiFranceCompetences::MakeRequest < MakeRequest::Get
  protected

  def mocking_params
    context.params
  end

  def request_uri
    URI(uri_with_siret)
  end

  def request_params
    {}
  end

  def extra_headers(request)
    super(request)

    request['Accept'] = 'application/json'
    request['token-connexion'] = Siade.credentials[:carif_oref_quiforme_token]
  end

  private

  def uri_with_siret
    URI("#{carif_oref_quiforme_url}/organisme/#{context.params[:siret]}")
  end

  def carif_oref_quiforme_url
    Siade.credentials[:carif_oref_quiforme_url]
  end
end
