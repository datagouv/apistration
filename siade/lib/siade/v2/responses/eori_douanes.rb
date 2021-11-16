class SIADE::V2::Responses::EORIDouanes < SIADE::V2::Responses::Generic
  protected

  def provider_name
    'DGDDI'
  end

  def adapt_raw_response_code
    case @raw_response.code.to_i
    when 200
      200
    when 400
      set_error_from_libelle
    when 403
      errors << ProviderAuthenticationError.new(provider_name)
      @http_code = 502
    when 404
      set_error_message_for(404)
      @raw_response.code.to_i
    else
      set_error_message_for(502)
      502
    end
  end

  def json_response
    JSON.parse(@raw_response.body, symbolize_names: true)
  end

  def error
    json_response[:erreur][:libelle]
  end

  def set_error_from_libelle
    if error == 'Format incorrect'
      set_error_message_for(422)
      422
    else
      set_error_message_for(502)
      502
    end
  end

  def set_error_message_422
    errors << UnprocessableEntityError.new(:siret_or_eori)
  end

  def set_error_message_404
    errors << NotFoundError.new(provider_name, 'Le numéro EORI indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel')
  end
end
