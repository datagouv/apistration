class INSEE::Etablissement::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI([base_uri, 'entreprises', 'sirene', 'V3', 'siret', siret].join('/'))
  end

  def request_params
    {}
  end

  def set_headers(request)
    request['Authorization'] = "Bearer #{token}"
    super(request)
  end

  def timeout_http_options
    {
      open_timeout: 2,
      read_timeout: 2
    }
  end

  private

  def siret
    context.params[:siret]
  end

  def token
    context.token
  end

  def base_uri
    Siade.credentials[:insee_v3_domain]
  end
end
