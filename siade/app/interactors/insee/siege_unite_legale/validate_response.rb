class INSEE::SiegeUniteLegale::ValidateResponse < INSEE::ValidateResponse
  private

  def validate_ok_response
    return unless more_than_one_siege?

    context.errors << INSEEError.new(:more_than_one_siege)
    context.fail!
  end

  def more_than_one_siege?
    json_body['etablissements'].many?
  end

  def not_found_message(_resource)
    'Le siren indiqué n\'existe pas, n\'est pas connu, est possiblement une entité pour laquelle aucun organisme ne peut avoir accès, ou ne comporte aucune information pour cet appel'
  end
end
