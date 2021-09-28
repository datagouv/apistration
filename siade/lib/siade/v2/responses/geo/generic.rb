class SIADE::V2::Responses::Geo::Generic < SIADE::V2::Responses::Generic
  protected

  def provider_name
    'API Geo'
  end

  def adapt_raw_response_code
    @raw_response.code.to_i
  end
end
