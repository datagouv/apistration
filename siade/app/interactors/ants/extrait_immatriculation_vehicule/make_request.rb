class ANTS::ExtraitImmatriculationVehicule::MakeRequest < MakeRequest::Post
  include UseANTSIssuedSSLCertificate
  include ResourceHelpers

  MODE_APPEL = 'L'.freeze

  protected

  def api_call_with_error_handling
    response = super

    return response unless stale_token_rejected?

    reauthenticate

    super
  end

  private

  def stale_token_rejected?
    context.token_renewed.blank? && http_unauthorized?
  end

  def reauthenticate
    context.token_renewed = true

    ANTS::Authenticate.invalidate_cached_token!
    ANTS::Authenticate.call!(context)
  end

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
