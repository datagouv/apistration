class SIADE::V2::Responses::Infogreffe < SIADE::V2::Responses::Generic
  protected

  def provider_name
    'Infogreffe'
  end

  def adapt_raw_response_code
    [
      '006 -DOSSIER NON TROUVE DANS LA BASE DE GREFFES',
      '008 -KBIS INDISPONIBLE POUR LE SIREN'
    ].each do |message|
      if @raw_response.body.include?(message)
        set_error_message_for(404)
        return 404
      end
    end

    [
      '005 -ABONNE INTERDIT-'
    ].each do |message|
      return 500 if @raw_response.body.include?(message)
    end

    @raw_response.code.to_i
  end
end
