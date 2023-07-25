class INPI::RNE::BeneficiairesEffectifs::ValidateResponse < ValidateResponse
  def call
    resource_not_found! if http_not_found?
    unknown_provider_response! if invalid_json?
    resource_not_found! if http_ok? && !personne_morale_data.key?('beneficiairesEffectifs')

    return if http_ok? && body_has_beneficiaires_effectifs?

    unknown_provider_response!
  end

  private

  def body_has_beneficiaires_effectifs?
    personne_morale_data['beneficiairesEffectifs'].present?
  end

  def personne_morale_data
    json_body['formality']['content']['personneMorale']
  end
end
