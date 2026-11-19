class ANTS::ExtraitImmatriculationVehicule::MakeRequest < MakeRequest::Post
  include UseANTSIssuedSSLCertificate

  MODE_APPEL = 'L'.freeze

  private

  def http_options
    http_ants_issued_ssl_options
  end

  def extra_headers(request)
    request['Content-Type'] = 'application/json'
    request['X-Http-Method-Override'] = 'GET'
    request['Authorization'] = "Bearer #{context.token}"
  end

  def mocking_params
    {
      immatriculation: context.params[:immatriculation]
    }
  end

  def request_uri
    URI(Siade.credentials[:ants_siv2_url])
  end

  def request_params
    {}
  end

  def build_request_body
    {
      modeAppel: MODE_APPEL,
      informations: { numImmat: context.params[:immatriculation]&.upcase }
    }.to_json
  end
end
