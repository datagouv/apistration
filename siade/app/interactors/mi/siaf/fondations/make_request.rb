class MI::SIAF::Fondations::MakeRequest < MakeRequest::Get
  protected

  def mocking_params
    {
      siren_or_siret_or_rnf: siren_or_siret_or_rnf.downcase
    }
  end

  def request_uri
    URI("#{siaf_url}/api/v1/fondations/#{fondation_path}")
  end

  def request_params
    {}
  end

  def extra_headers(request)
    super
    request['Accept'] = 'application/json'
    request['Token'] = siaf_token
  end

  def http_options
    super.merge(cert_store: ministere_interieur_cert_store)
  end

  private

  def api_call
    super
  rescue OpenSSL::X509::StoreError => e
    fail_to_ssl_handshake!(e)
  end

  def fondation_path
    if Siret.new(siren_or_siret_or_rnf).valid?
      "by_siret/#{siren_or_siret_or_rnf}"
    elsif Siren.new(siren_or_siret_or_rnf).valid?
      "by_siren/#{siren_or_siret_or_rnf}"
    else
      siren_or_siret_or_rnf.upcase
    end
  end

  def ministere_interieur_cert_store
    OpenSSL::X509::Store.new.tap do |store|
      store.set_default_paths
      store.add_file(Siade.credentials[:siaf_certificate_chain_path])
    end
  end

  def siren_or_siret_or_rnf
    context.params[:siren_or_siret_or_rnf]
  end

  def siaf_url
    Siade.credentials[:siaf_url]
  end

  def siaf_token
    Siade.credentials[:siaf_token]
  end
end
