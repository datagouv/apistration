class CNAF::QuotientFamilial::MakeRequest < MakeRequest::Post
  protected

  def request_uri
    URI(cnaf_quotient_familial_url)
  end

  def build_request_body
    CNAFQuotientFamilialSoapBuilder.new(postal_code, beneficiary_number).render
  end

  def set_headers(request)
    request['Content-Type'] = 'text/xml; charset=utf-8'
  end

  def http_options
    {
      use_ssl: true,
      verify_mode: OpenSSL::SSL::VERIFY_PEER,
      cert: ssl_certificate,
      key: ssl_certificate_key
    }
  end

  private

  def ssl_certificate_key
    raw_key = Rails.root.join(Siade.credentials[:cnaf_quotient_familial_certificate_key_path]).read
    OpenSSL::PKey::RSA.new(raw_key)
  end

  def ssl_certificate
    raw_cert = Rails.root.join(Siade.credentials[:cnaf_quotient_familial_certificate_path]).read
    OpenSSL::X509::Certificate.new(raw_cert)
  end

  def cnaf_quotient_familial_url
    Siade.credentials[:cnaf_quotient_familial_url]
  end

  def beneficiary_number
    context.params[:beneficiary_number]
  end

  def postal_code
    context.params[:postal_code]
  end
end
