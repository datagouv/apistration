class FNTP::CarteProfessionnelleTravauxPublics::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI.parse("https://fntp_domain.gouv.fr/rip/sgmap/#{siren}/cartepro")
  end

  def set_headers(request)
    request['Content-Type'] = 'application/pdf'
    super(request)
  end

  def request_params
    {
      token: token
    }
  end

  private

  def siren
    context.params[:siren]
  end

  def token
    Siade.credentials[:fntp_token]
  end
end
