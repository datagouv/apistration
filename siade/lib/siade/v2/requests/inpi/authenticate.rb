class SIADE::V2::Requests::INPI::Authenticate
  def cookie
    @cookie = response['set-cookie']
      .match(/(JSESSIONID=.+); Path=.+/)
      .captures
      .first
  rescue NoMethodError
    @cookie = nil
  end

  def provider_name
    'INPI'
  end

  private

  def response
    Net::HTTP.start(uri.hostname, uri.port, request_options) do |http|
      http.request request
    end
  rescue Net::OpenTimeout, Net::ReadTimeout, Errno::ECONNREFUSED, Errno::ECONNRESET, SocketError, EOFError
    nil
  end

  def request
    request = Net::HTTP::Post.new uri
    request['login'] = inpi_login
    request['password'] = inpi_password
    request
  end

  def uri
    URI inpi_uri + '/login'
  end

  def request_options
    {
      use_ssl: true,
      verify_mode: OpenSSL::SSL::VERIFY_NONE
    }
  end

  def inpi_login
    Siade.credentials[:inpi_login]
  end

  def inpi_password
    Siade.credentials[:inpi_password]
  end

  def inpi_uri
    Siade.credentials[:inpi_url]
  end
end
