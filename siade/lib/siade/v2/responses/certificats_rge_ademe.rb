class SIADE::V2::Responses::CertificatsRGEADEME < SIADE::V2::Responses::Generic
  def json_body
    JSON.parse(body_without_bom)
  rescue JSON::ParserError
    @payload_with_description = true
    JSON.parse(body_without_bom.split("\n")[-1])
  end

  protected

  def body_without_bom
    @body_without_bom ||= body.force_encoding('UTF-8').sub(/^\xEF\xBB\xBF/, '')
  end

  def provider_name
    'ADEME'
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
    json_body

    if @payload_with_description
      payload_with_description_has_an_empty_company?
    else
      json_body == []
    end
  end

  def payload_with_description_has_an_empty_company?
    json_body['Company'].is_a?(Array) && json_body['Company'][0]['id'].nil?
  end
end
