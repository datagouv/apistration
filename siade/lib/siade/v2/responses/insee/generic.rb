class SIADE::V2::Responses::INSEE::Generic < SIADE::V2::Responses::Generic
  protected

  def provider_name
    'INSEE'
  end

  def adapt_raw_response_code
    case @raw_response.code.to_i
    when 403
      set_error_message_for(451)
      451
    else
      @raw_response.code.to_i
    end
  end

  private

  def set_error_message_451
    (@errors ||= []) << ::UnavailableForLegalReasonsError.new('INSEE', 'Le siren ou siret demandé est une entité pour laquelle aucun organisme ne peut avoir accès.')
  end
end
