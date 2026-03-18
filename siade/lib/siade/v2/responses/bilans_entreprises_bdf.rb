class SIADE::V2::Responses::BilansEntreprisesBDF < SIADE::V2::Responses::Generic

  def body
    @decrypted_body ||= Zlib::GzipReader.new(StringIO.new(@body)).read
  rescue Zlib::GzipFile::Error
    @decrypted_body = @body
  ensure
    @decrypted_body
  end

  protected

  def provider_name
    'Banque de France'
  end

  def adapt_raw_response_code
    if no_data?
      errors << NotFoundError.new(provider_name)
      404
    elsif bdd_error?
      errors << BDFError.new(:bdd_error)
      503
    elsif internal_server_error?
      errors << BDFError.new(:internal_error)
      503
    else
      raw_functionnal_http_code || @raw_response.code.to_i
    end
  end

  private

  def parsed_body
    if body
      JSON.parse(body)
    else
      { }
    end
  end

  def raw_functionnal_http_code
    parsed_body['code-retour']
  end

  def no_data?
    raw_functionnal_http_code == 204
  end

  def bdd_error?
    raw_functionnal_http_code == 501
  end

  def internal_server_error?
    raw_functionnal_http_code == 500
  end
end
