class QUALIBAT::CertificationsBatiment::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI(Siade.credentials[:qualibat_url])
  end

  def request_params
    {
      token:,
      SIRET: siret
    }
  end

  def token
    Siade.credentials[:qualibat_token]
  end

  def siret
    context.params[:siret]
  end
end
