class SIADE::V2::Responses::CotisationsMSA < SIADE::V2::Responses::Generic
  protected

  def provider_name
    'MSA'
  end

  def adapt_raw_response_code
    if etablissement_not_found?
      set_error_message_for(404)
    else
      @raw_response.code.to_i
    end
  end

  private

  def etablissement_not_found?
    parsed_body = JSON.parse(@body)
    parsed_body['TopRMPResponse']['topRegMarchePublic'] == 'S'
  end
end
