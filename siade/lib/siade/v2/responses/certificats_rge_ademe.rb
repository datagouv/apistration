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

    if http_status == 404 || empty_body? || body_without_valid_details_nor_domaines?
      set_error_message_for(404)
    else
      http_status
    end
  end

  private

  def empty_body?
    json_body['Company'].is_a?(Array) &&
      json_body['Company'][0]['id'].nil?
  end

  def body_without_valid_details_nor_domaines?
    json_body['Company'].is_a?(Array)
  end
end
