class APIEntreprise::ACOSS::AttestationSocialeSerializer::V4 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :document_url,
    :document_url_expires_in,
    :date_debut_validite,
    :code_securite

  attribute :entity_status do |object|
    {
      code: object.entity_status_code
    }
  end
end
