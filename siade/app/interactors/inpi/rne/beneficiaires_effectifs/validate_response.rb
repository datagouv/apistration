class INPI::RNE::BeneficiairesEffectifs::ValidateResponse < INPI::RNE::Company::ValidateResponse
  def call
    super

    resource_not_found! if unite_legale_has_no_beneficiaires_effectifs?

    return if personne_morale_has_beneficiaires_effectifs?

    unknown_provider_response!
  end

  private

  def unite_legale_has_no_beneficiaires_effectifs?
    personne_physique? ||
      !personne_morale? ||
      !personne_morale_has_beneficiaires_effectifs?
  end

  def personne_physique?
    personne_morale_data.blank? &&
      json_body['formality']['content']['personnePhysique'].present?
  end

  def personne_morale?
    personne_morale_data.present?
  end

  def personne_morale_has_beneficiaires_effectifs?
    personne_morale_data['beneficiairesEffectifs'].present?
  end

  def personne_morale_data
    json_body['formality']['content']['personneMorale']
  end
end
