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
    if empty_body?
      set_error_message_for(404)
    else
      @raw_response.code.to_i
    end
  end

  private

  def empty_body?
    if new_temporary_format?
      new_temporary_format_404?
    else
      json_body == []
    end
  end

  def new_temporary_format?
    return false if json_body == []

    new_temporary_format_200? ||
      new_temporary_format_404?
  end

  def new_temporary_format_200?
    json_body['Company'].is_a?(Hash)
  end

  def new_temporary_format_404?
    json_body['Company'].is_a?(Array) &&
      json_body['Company'][0]['id'].nil?
  end
end
