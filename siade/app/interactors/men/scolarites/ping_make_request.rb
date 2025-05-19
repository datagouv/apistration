class MEN::Scolarites::PingMakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI(Siade.credentials[:men_scolarites_ping_url])
  end

  def extra_headers(request)
    request['Authorization'] = "Bearer #{context.token}"

    super
  end

  def request_params
    {}
  end
end
