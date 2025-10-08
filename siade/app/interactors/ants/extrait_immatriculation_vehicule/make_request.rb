class ANTS::ExtraitImmatriculationVehicule::MakeRequest < MakeRequest::Post
  include UseWildcardSSLCertificate

  private

  def http_options
    http_wildcard_ssl_options.merge(
      ca_file: Siade.credentials[:ants_siv_certificate_chain_path]
    )
  end

  def extra_headers(request)
    request['Content-Type'] = 'application/soap+xml; charset=utf-8'
    request['SOAPAction'] = ''
  end

  def mocking_params
    {
      immatriculation: context.params[:immatriculation]
    }
  end

  def request_uri
    URI(Siade.credentials[:ants_siv_url])
  end

  def request_params
    {}
  end

  def build_request_body
    ANTSDossierImmatriculationSoapBuilder.new(
      immatriculation: context.params[:immatriculation].upcase,
      ants_request_id:,
      certificate: cert,
      private_key: key
    ).render
  end

  def ants_request_id
    context.params[:request_id] ? "req_#{context.params[:request_id]}" : "rnd_#{SecureRandom.uuid}"
  end
end
