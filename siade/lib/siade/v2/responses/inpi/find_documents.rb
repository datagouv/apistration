class SIADE::V2::Responses::INPI::FindDocuments < SIADE::V2::Responses::Generic
  protected

  def provider_name
    'INPI'
  end

  def adapt_raw_response_code
    if empty_body?
      set_error_message_for(404)
    else
      raw_response.code.to_i
    end
  end

  private

  def empty_body?
    JSON.parse(body).empty?
  end
end
