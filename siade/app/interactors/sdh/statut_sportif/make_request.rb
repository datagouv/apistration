class SDH::StatutSportif::MakeRequest < MakeRequest::Get
  protected

  def mocking_params
    {
      identifiant: context.params[:identifiant]
    }
  end

  def request_uri
    URI("#{sdh_endpoint_url}/#{identifiant}")
  end

  def request_params
    {}
  end

  def extra_headers(request)
    request['Authorization'] = "Bearer #{context.token}"
  end

  private

  def sdh_endpoint_url
    Siade.credentials[:sdh_endpoint_url]
  end

  def identifiant
    context.params[:identifiant]
  end
end
