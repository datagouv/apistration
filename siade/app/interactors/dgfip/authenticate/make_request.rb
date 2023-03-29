class DGFIP::Authenticate::MakeRequest < MakeRequest::Post
  def request_uri
    URI(Siade.credentials[:dgfip_authenticate_url])
  end

  def extra_headers(request)
    request['Content-Type'] = 'application/x-www-form-urlencoded'
  end

  def form_data
    {
      secret:,
      identifiant: login,
      mdp:
    }
  end

  private

  def login
    Siade.credentials[:dgfip_login]
  end

  def secret
    Siade.credentials[:dgfip_secret]
  end

  def mdp
    Siade.credentials[:dgfip_mdp]
  end
end
