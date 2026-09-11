class ANTS::ExtraitImmatriculationVehicule::MakeRequest < MakeRequest::Post
  private

  def http_options
    {
      use_ssl: true,
      verify_mode: OpenSSL::SSL::VERIFY_PEER,
      cert:,
      key:
    }
  end

  def cert
    raw_cert = File.read(Siade.credentials[:ants_siv_client_certificate_path])
    OpenSSL::X509::Certificate.new(raw_cert)
  end

  def key
    raw_key = File.read(Siade.credentials[:ants_siv_client_certificate_key_path])
    OpenSSL::PKey::RSA.new(raw_key)
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
