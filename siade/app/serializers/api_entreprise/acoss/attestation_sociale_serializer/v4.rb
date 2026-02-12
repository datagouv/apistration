class APIEntreprise::ACOSS::AttestationSocialeSerializer::V4 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :document_url,
    :document_url_expires_in

  attribute :date_debut_validite do
    safe_data_attribute(:date_debut_validite)
  end

  attribute :date_fin_validite do
    safe_data_attribute(:date_fin_validite)
  end

  attribute :code_securite do
    safe_data_attribute(:code_securite)
  end

  attribute :entity_status do
    code = safe_data_attribute(:entity_status_code)

    {
      code:
    }.compact.merge(
      extract_entity_status_humanized_info(code)
    )
  end

  def extract_entity_status_humanized_info(code)
    case code
    when 'ok'
      {
        libelle: "Attestation délivrée par l'Urssaf",
        description: "La délivrance de l'attestation de vigilance a été validée par l'Urssaf. L'attestation est délivrée lorsque l'entité est à jour de ses cotisations et contributions, ou bien dans le cas de situations spécifiques détaillées dans la documentation métier."
      }
    when 'refus_de_delivrance'
      {
        libelle: "Délivrance de l'attestation refusée par l'Urssaf",
        description: "La délivrance de l'attestation de vigilance a été refusée par l'Urssaf car l'entité n'est pas à jour de ses cotisations sociales."
      }
    else
      {}
    end
  end

  private

  def safe_data_attribute(attribute)
    return unless data.respond_to?(attribute)

    data.public_send(attribute)
  end
end
