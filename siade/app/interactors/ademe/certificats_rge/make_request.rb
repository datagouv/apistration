class ADEME::CertificatsRGE::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI(ademe_rge_url)
  end

  def request_params
    {
      size:,
      qs: "siret:#{siret}"
    }
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
    context.params[:size]
  end
end
