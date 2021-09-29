class INSEE::Entreprise::ValidateResponse < ValidateResponse
  def call
    return if http_ok?

    if http_not_found?
      resource_not_found!
    elsif http_forbidden?
      fail_with_error!(build_error(::UnavailableForLegalReasonsError, unavailable_for_legal_reason_message))
    else
      unknown_provider_response!
    end
  end

  private

  def unavailable_for_legal_reason_message
    'Le siren demandé est une entité pour laquelle aucun organisme ne peut avoir accès.'
  end
end
