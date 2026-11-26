class GIPMDS::ServiceCivique::ValidateResponse < ValidateResponse
  raises ProviderUnprocessableEntityError, reason: :ambiguous_identity

  def call
    unknown_provider_response! if unreadable_body?
    resource_not_found! if not_found?
    too_many_individus! if too_many_individus?
    unknown_provider_response! unless complete_response?
    resource_not_found! if retained_contracts.empty?
    several_service_civiques! if retained_contracts.many?
  end

  private

  def unreadable_body?
    body.blank? || invalid_json?
  end

  def complete_response?
    http_code == 200 && json_body.key?('individu')
  end

  def retained_contracts
    @retained_contracts ||= GIPMDS::ServiceCivique::Contracts.new(json_body).retained
  end

  def several_service_civiques!
    unknown_provider_response!(
      "Plusieurs contrats de service civique sont déclarés pour cette personne, alors qu'une personne ne peut effectuer qu'un seul service civique : la réponse du fournisseur est incohérente et nous ne pouvons pas déterminer le bon contrat."
    )
  end

  def not_found?
    http_code == 404 && %w[NOT_FOUND_INDIVIDU NOT_FOUND_CONTRAT].include?(error_code)
  end

  def too_many_individus?
    http_code == 413 && error_code == 'TOO_MANY_INDIVIDU'
  end

  def too_many_individus!
    unprocessable_entity!(
      :ambiguous_identity,
      "Les paramètres d'identité correspondent à plusieurs personnes. Nous ne pouvons pas fournir les informations de service civique pour cet individu."
    )
  end

  def error_code
    json_body.dig('erreurs', 0, 'code')
  end
end
