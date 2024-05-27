class INSEE::MakeRequest < MakeRequest::Get
  protected

  def extra_headers(request)
    request['Authorization'] = "Bearer #{token}"
    super
  end

  def extra_http_start_options
    {
      open_timeout: 2,
      read_timeout: 2
    }
  end

  def token
    context.token
  end

  def sirene_version
    'sirene/V3.11'
  end

  def base_uri
    Siade.credentials[:insee_v3_domain]
  end
end
