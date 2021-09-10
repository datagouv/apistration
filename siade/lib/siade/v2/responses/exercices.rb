class SIADE::V2::Responses::Exercices < SIADE::V2::Responses::Generic
  protected

  def provider_name
    'DGFIP'
  end

  def adapt_raw_response_code
    if @raw_response.body == 'null'
      set_error_message_for(404)
      404
    elsif @raw_response.code.to_i == 302
      set_error_message_for_unexpected_redirection
      502
    else
      @raw_response.code.to_i
    end
  end

  def set_error_message_for_unexpected_redirection
    (@errors ||= []) << ProviderUnknownError.new('DGFIP', 'Erreur de la DGFIP, celle intervient généralement lorsque l\'organisme n\'est pas soumis à l\'impôt sur les sociétés. Si c\'est bien le cas il est possible que les comptes n\'est pas encore été déposés aux greffes.')
  end
end
