class CNETP::AttestationCotisationsCongesPayesChomageIntemperies::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI("#{cnetp_domain}/webservice/doc/attestations/entreprises")
  end

  def request_params
    {
      id: client_number,
      jeton: token,
      siren: siren
    }
  end

  def set_headers(request)
    request['Content-Type'] = 'application/octet-stream'
    super(request)
  end

  private

  def cnetp_domain
    Siade.credentials[:cnetp_domain]
  end

  def siren
    context.params[:siren]
  end

  def token
    Siade.credentials[:cnetp_token]
  end

  def client_number
    Siade.credentials[:cnetp_client_number]
  end
end
