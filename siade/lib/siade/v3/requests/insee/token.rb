require 'net/http'
require 'uri'
require 'openssl'

class SIADE::V3::Requests::INSEE::Token
  def token
    response_body['access_token']
  end

  def expiration_date
    expires_in.to_i.seconds.from_now.to_i
  end

  def expires_in
    response_body['expires_in']
  end

  def provider_name
    'INSEE'
  end

  private

  def response_body
    @response_body ||= JSON.parse(http_response.body)
  end

  def http_response
    Net::HTTP.start(uri.hostname, uri.port, request_options) do |http|
      http.request(request)
    end
  end

  def request
    request = Net::HTTP::Post.new(uri)
    request['Authorization'] = 'Basic ' + insee_credentials
    request.set_form_data(grant_type: 'client_credentials')
    request
  end

  def request_options
    {
      use_ssl: true,
      verify_mode: OpenSSL::SSL::VERIFY_NONE
    }
  end

  def uri
    URI([insee_uri, 'token'].join('/'))
  end

  def insee_credentials
    Siade.credentials[:insee_credentials]
  end

  def insee_uri
    Siade.credentials[:insee_v3_domain]
  end
end
