class QUALIBAT::CertificationsBatiment::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI(request_url)
  end

  def request_url
    [
      Siade.credentials[:qualibat_api_url],
      'certificat',
      siret
    ].join('/')
  end

  def request_params
    {}
  end

  def extra_headers(request)
    request['Authorization'] = "Bearer #{token}"
  end

  def token
    context.token
  end

  def siret
    context.params[:siret]
  end
end
