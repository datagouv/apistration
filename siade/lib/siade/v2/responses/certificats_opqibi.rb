class SIADE::V2::Responses::CertificatsOPQIBI < SIADE::V2::Responses::Generic
  protected

  def provider_name
    'OPQIBI'
  end

  def adapt_raw_response_code
    @raw_response.code.to_i
  end
end
