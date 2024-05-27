class ADEME::CertificatsRGE::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI(ademe_rge_url)
  end

  def request_params
    {
      size:,
      qs: "siret:#{siret} AND traitement_termine:false"
    }
  end

  def extra_headers(request)
    request['x-apiKey'] = ademe_token
    request['Referer'] = current_host_url
    super
  end

  private

  def ademe_rge_url
    Siade.credentials[:ademe_rge_url]
  end

  def ademe_token
    Siade.credentials[:ademe_rge_token]
  end

  def siret
    context.params[:siret]
  end

  def size
    context.params[:limit]
  end
end
