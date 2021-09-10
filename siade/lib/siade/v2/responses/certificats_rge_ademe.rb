class SIADE::V2::Responses::CertificatsRGEAdeme < SIADE::V2::Responses::Generic
  protected

  def provider_name
    'Ademe'
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
    JSON.parse(body_without_bom) == []
  end

  def body_without_bom
    body.force_encoding('UTF-8').sub(/^\xEF\xBB\xBF/, '')
  end
end
