class SIADE::V2::Responses::ConventionsCollectives < SIADE::V2::Responses::Generic
  protected

  def provider_name
    'Fabrique numérique des Ministères Sociaux'
  end

  def adapt_raw_response_code
    if error_404?
      set_error_message_for(404)
    else
      @raw_response.code.to_i
    end
  end

  private

  def response_json
    @response_json ||= JSON.parse(body).first
  end

  def error_404?
    response_json["conventions"].empty?
  end
end
