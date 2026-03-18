class SIADE::V2::Responses::CertificatsAgenceBIO < SIADE::V2::Responses::Generic
  protected

  def provider_name
    'Agence BIO'
  end

  def adapt_raw_response_code
    if empty_body?
      set_error_message_for(404)
    else
      @raw_response.code.to_i
    end
  end

  private

  def empty_body?
    parsed_body = JSON.parse(body, symbolize_names: true)
    parsed_body[:items].empty?
  end
end
