class APIEntreprise::ACOSS::AttestationSocialeSerializer::V4 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :document_url,
    :document_url_expires_in,
    :date_debut_validite,
    :date_fin_validite,
    :code_securite

  attribute :entity_status do
    {
      code: data.entity_status_code
    }.merge(
      extract_entity_status_humanized_info(data.entity_status_code)
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
end
