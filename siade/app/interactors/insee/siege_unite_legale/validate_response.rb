class INSEE::SiegeUniteLegale::ValidateResponse < ValidateResponse
  def call
    if http_ok? && valid_json?
      if more_than_one_siege?
        context.errors << INSEEError.new(:more_than_one_siege)
        context.fail!
      end
    elsif http_not_found?
      resource_not_found!
    elsif http_internal_error?
      internal_server_error!
    else
      unknown_provider_response!
    end
  end

  private

  def more_than_one_siege?
    json_body['etablissements'].many?
  end

  def not_found_message(_resource)
    'Le siren indiqué n\'existe pas, n\'est pas connu, est possiblement une entité pour laquelle aucun organisme ne peut avoir accès, ou ne comporte aucune information pour cet appel'
  end
end
