class INPI::Actes::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI([inpi_domain, 'actes', 'find'].join('/'))
  end

  def request_params
    {
      siren: siren
    }
  end

  def set_headers(request)
    request['Cookie'] = context.cookie
    super(request)
  end

  private

  def inpi_domain
    Siade.credentials[:inpi_url]
  end

  def siren
    context.params[:siren]
  end
end
