class INPI::Authenticate::MakeRequest < MakeRequest::Post
  protected

  def request_uri
    URI "#{inpi_url}/login"
  end

  def set_headers(request)
    request['login'] = inpi_login
    request['password'] = inpi_password
    request['Content-Type'] = 'application/json'
  end

  private

  def inpi_url
    Siade.credentials[:inpi_url]
  end

  def inpi_login
    Siade.credentials[:inpi_login]
  end

  def inpi_password
    Siade.credentials[:inpi_password]
  end
end
