class SIADE::V2::Responses::CertificatsRGEADEME < SIADE::V2::Responses::Generic
  def json_body
    JSON.parse(body_without_bom)
  end

  protected

  def body_without_bom
    @body_without_bom ||= body.force_encoding('UTF-8').sub(/^\xEF\xBB\xBF/, '')
  end

  def provider_name
    'ADEME'
  end

  def adapt_raw_response_code
    http_status = @raw_response.code.to_i

    if http_status == 404 || entity_without_id? || entity_without_valid_qualifications_or_domaines?
      set_error_message_for(404)
    else
      http_status
    end
  end

  private

  def payload
    json_body['Company']
  end

  def entity
    payload[0]
  end

  def entity_without_id?
    entity['id'].nil?
  end

  def entity_without_valid_qualifications_or_domaines?
    entity['domaines'].empty? ||
      entity['qualifications'].empty?
  end
end
