class SIADE::V2::Responses::EntreprisesArtisanales < SIADE::V2::Responses::Generic
  protected

  def provider_name
    'CMA France'
  end

  def adapt_raw_response_code
    @raw_response.code.to_i
  end
end
