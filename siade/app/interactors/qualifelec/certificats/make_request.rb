class Qualifelec::Certificats::MakeRequest < MakeRequest::Get
  protected

  def mocking_params
    {
      siret:
    }
  end

  def request_uri
    URI("#{Siade.credentials[:qualifelec_certificates_url]}/#{siret}")
  end

  def request_params
    {}
  end

  def extra_headers(request)
    request['Authorization'] = "Bearer #{token}"
    request['Content-Type'] = 'application/json'
  end

  private

  def siret
    context.params[:siret]
  end

  def token
    context.token
  end
end
