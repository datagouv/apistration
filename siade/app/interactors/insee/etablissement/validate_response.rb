class INSEE::Etablissement::ValidateResponse < INSEE::UniteLegale::ValidateResponse
  private

  def unavailable_for_legal_reason_message
    'Le siret demandé est une entité pour laquelle aucun organisme ne peut avoir accès.'
  end

  def not_found_message
    'Le siret indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel'
  end
end
