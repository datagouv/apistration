class SIADE::V2::Responses::CartesProfessionnellesFNTP < SIADE::V2::Responses::Generic
  protected

  def provider_name
    'FNTP'
  end

  def adapt_raw_response_code
    @raw_response.code
  end
end
