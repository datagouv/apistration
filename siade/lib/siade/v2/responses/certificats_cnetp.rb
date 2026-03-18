class SIADE::V2::Responses::CertificatsCNETP < SIADE::V2::Responses::Generic

  protected

  def provider_name
    'CNETP'
  end

  def adapt_raw_response_code
    @raw_response.code
  end
end
