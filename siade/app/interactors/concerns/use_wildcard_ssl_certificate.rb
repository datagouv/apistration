module UseWildcardSSLCertificate
  def http_wildcard_ssl_options
    {
      use_ssl: true,
      verify_mode: OpenSSL::SSL::VERIFY_PEER,
      cert:,
      key:
    }
  end

  def key
    raw_key = File.read(Siade.credentials[:ssl_wildcard_certif_key_path])
    OpenSSL::PKey::RSA.new(raw_key)
  end

  def cert
    raw_cert = File.read(Siade.credentials[:ssl_wildcard_certif_crt_path])
    OpenSSL::X509::Certificate.new(raw_cert)
  end
end
