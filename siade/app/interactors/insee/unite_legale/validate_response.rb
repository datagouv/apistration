class INSEE::UniteLegale::ValidateResponse < INSEE::ValidateResponse
  private

  def handle_forbidden!
    fail_with_error!(build_error(::UnavailableForLegalReasonsError, unavailable_for_legal_reason_message))
  end

  def unavailable_for_legal_reason_message
    'Le siren demandé est une entité pour laquelle aucun organisme ne peut avoir accès.'
  end
end
