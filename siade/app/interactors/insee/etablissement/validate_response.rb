class INSEE::Etablissement::ValidateResponse < INSEE::UniteLegale::ValidateResponse
  declares_no_specific_errors!

  private

  def unavailable_for_legal_reason_message
    'Le siret demandé est une entité pour laquelle aucun organisme ne peut avoir accès.'
  end
end
