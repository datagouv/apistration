class SIADE::V2::Responses::CertificatsQUALIBAT < SIADE::V2::Responses::Generic
  protected

  def provider_name
    'Qualibat'
  end

  def adapt_raw_response_code
    @raw_response.code.to_i
  end
end
