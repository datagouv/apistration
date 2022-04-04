class FNTP::CarteProfessionnelleTravauxPublics::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI.parse("#{fntp_domain}/rip/sgmap/#{siren}/cartepro")
  end

  def set_headers(request)
    request['Content-Type'] = 'application/pdf'
    super(request)
  end

  def request_params
    {
      token:
    }
  end

  private

  def fntp_domain
    Siade.credentials[:fntp_domain]
  end

  def siren
    context.params[:siren]
  end

  def token
    Siade.credentials[:fntp_token]
  end
end
