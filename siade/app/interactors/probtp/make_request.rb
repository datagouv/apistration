class PROBTP::MakeRequest < MakeRequest::Post
  protected

  def request_params
    {
      corps: siret
    }
  end

  def http_options
    {
      use_ssl: true,
      verify_mode: OpenSSL::SSL::VERIFY_PEER,
      cert:,
      key:
    }
  end

  def probtp_domain
    Siade.credentials[:probtp_domain]
  end

  private

  def key
    raw_key = File.read(Siade.credentials[:ssl_wildcard_certif_key_path])
    OpenSSL::PKey::RSA.new(raw_key)
  end

  def cert
    raw_cert = File.read(Siade.credentials[:ssl_wildcard_certif_crt_path])
    OpenSSL::X509::Certificate.new(raw_cert)
  end

  def siret
    context.params[:siret]
  end
end
