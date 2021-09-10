class SIADE::V2::Requests::AuthenticateDGFIP < SIADE::V2::Requests::Generic
  def cookie
    @response.cookie
  end

  def success?
    response.http_code == 200
  end

  def valid?
    true
  end

  protected

  def provider_name
    'DGFIP'
  end

  def request_lib
    :net_http
  end

  def request_verb
    :post
  end

  def response_wrapper
    SIADE::V2::Responses::AuthenticateDGFIP
  end

  def request_uri
    URI(Siade.credentials[:dgfip_authenticate_url])
  end

  def net_http_options
    { use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE }
  end

  def net_http_post_call
    @raw_response = Net::HTTP.start(request_uri.host, request_uri.port, net_http_options) do |http|
      request = Net::HTTP::Post.new(request_uri)
      request.set_form_data(secret: secret, identifiant: identifiant_email, mdp: '')
      http.request(request)
    end

    @response = response_wrapper.new(raw_response)
  end

  private

  def identifiant_email
    Siade.credentials[:dgfip_login]
  end

  def secret
    Siade.credentials[:dgfip_secret]
  end
end
