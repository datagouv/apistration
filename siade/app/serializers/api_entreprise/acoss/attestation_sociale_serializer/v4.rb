class APIEntreprise::ACOSS::AttestationSocialeSerializer::V4 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :document_url,
    :document_url_expires_in,
    :date_debut_validite,
    :date_fin_validite,
    :code_securite

  attribute :entity_status do |object|
    {
      code: object.entity_status_code
    }.merge(
      extract_entity_status_humanized_info(object.entity_status_code)
    )
  end

  def self.extract_entity_status_humanized_info(code)
    case code
    when 'ok'
      {
        libelle: "Attestation délivrée par l'Urssaf",
        description: "La délivrance de l'attestation de vigilance a été validée par l'Urssaf. L'attestation est délivrée lorsque l'entité est à jour de ses cotisations et contributions, ou bien dans le cas de situations spécifiques détaillées dans la documentation métier."
      }
    when 'refus_de_delivrance'
      {
        libelle: "Délivrance de l'attestation refusée par l'Urssaf",
        description: "La délivrance de l'attestation de vigilance a été refusée par l'Urssaf car la situation de l'entreprise n'entre pas dans le cadre précis de délivrance. Consulter la documentation métier pour en savoir plus."
      }
    else
      {}
    end
  end
end
